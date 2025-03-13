// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IPendlePriceCapAdapter, ICLSynchronicityPriceAdapter, IACLManager, IChainlinkAggregator} from '../interfaces/IPendlePriceCapAdapter.sol';
import {IPendlePrincipalToken} from '../interfaces/IPendlePrincipalToken.sol';

/**
 * @title PendlePriceCapAdapter
 * @author BGD Labs
 * @notice Price adapter to cap the price of the PT-tokens.
 * This adapter uses a linear discount decay model, from `maxDiscountPerYear * timeToMaturity` to 0 after and at maturity.
 * `_maxDiscountPerYear` cannot be increased after initial setup, only decreased.
 *
 * The price of PT token (PT_price) is calculated as:
 *
 * currentDiscount = (maturity - block.timestamp) * _maxDiscountPerYear / SECONDS_PER_YEAR
 * PT_price = priceOfAsset - (priceOfAsset * linearCurrentDiscount / PERCENTAGE_FACTOR)
 */
contract PendlePriceCapAdapter is IPendlePriceCapAdapter {
  /// @inheritdoc IPendlePriceCapAdapter
  uint256 public constant PERCENTAGE_FACTOR = 1e4; // 100%

  /// @inheritdoc IPendlePriceCapAdapter
  uint256 public constant SECONDS_PER_YEAR = 365 days;

  /// @inheritdoc IPendlePriceCapAdapter
  IPendlePrincipalToken public immutable PENDLE_PRINCIPAL_TOKEN;

  /// @inheritdoc IPendlePriceCapAdapter
  IChainlinkAggregator public immutable ASSET_TO_USD_AGGREGATOR;

  /// @inheritdoc IPendlePriceCapAdapter
  IACLManager public immutable ACL_MANAGER;

  /// @inheritdoc IPendlePriceCapAdapter
  uint256 public immutable MATURITY;

  /// @inheritdoc IPendlePriceCapAdapter
  uint8 public immutable DECIMALS;

  /**
   * @notice Description of the adapter
   */
  string private _description;

  /**
   * @notice The maximum APY that is set for a given asset before maturity occurs
   */
  uint16 private _maxDiscountPerYear;

  constructor(PendlePriceCapAdapterParams memory params) {
    if (
      params.assetToUsdAggregator == address(0) ||
      params.pendlePrincipalToken == address(0) ||
      params.aclManager == address(0)
    ) {
      revert ZeroAddress();
    }

    ACL_MANAGER = IACLManager(params.aclManager);

    ASSET_TO_USD_AGGREGATOR = IChainlinkAggregator(params.assetToUsdAggregator);
    DECIMALS = ASSET_TO_USD_AGGREGATOR.decimals();

    PENDLE_PRINCIPAL_TOKEN = IPendlePrincipalToken(params.pendlePrincipalToken);
    MATURITY = PENDLE_PRINCIPAL_TOKEN.expiry();

    if (MATURITY <= block.timestamp) {
      revert MaturityHasAlreadyPassed();
    }

    _description = params.description;

    _setMaxDiscountPerYear(params.maxDiscountPerYear);
  }

  /// @inheritdoc IPendlePriceCapAdapter
  function setMaxDiscountPerYear(uint16 maxDiscountPerYear) external {
    if (!ACL_MANAGER.isRiskAdmin(msg.sender) && !ACL_MANAGER.isPoolAdmin(msg.sender)) {
      revert CallerIsNotRiskOrPoolAdmin();
    }

    _setMaxDiscountPerYear(maxDiscountPerYear);
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() external view returns (int256) {
    int256 currentAssetPrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();
    if (currentAssetPrice <= 0) {
      return 0;
    }

    int256 currentDiscount = int256(getCurrentDiscount());
    int256 price = currentAssetPrice -
      (currentAssetPrice * currentDiscount) /
      int256(PERCENTAGE_FACTOR);

    return price;
  }

  /// @inheritdoc IPendlePriceCapAdapter
  function getMaxDiscountPerYear() external view returns (uint256) {
    return _maxDiscountPerYear;
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function description() external view returns (string memory) {
    return _description;
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function decimals() external view returns (uint8) {
    return DECIMALS;
  }

  /// @inheritdoc IPendlePriceCapAdapter
  function getCurrentDiscount() public view returns (uint256) {
    uint256 timeToMaturity = (MATURITY > block.timestamp) ? MATURITY - block.timestamp : 0;

    return (timeToMaturity * _maxDiscountPerYear) / SECONDS_PER_YEAR;
  }

  function _setMaxDiscountPerYear(uint16 maxDiscountPerYear) internal {
    uint16 oldMaxDiscountPerYear = _maxDiscountPerYear;

    if (maxDiscountPerYear == 0 || oldMaxDiscountPerYear <= maxDiscountPerYear) {
      revert InvalidNewMaxDiscountPerYear();
    }

    if (
      ((MATURITY - block.timestamp) * maxDiscountPerYear) / SECONDS_PER_YEAR >= PERCENTAGE_FACTOR
    ) {
      revert DiscountExceeds100Percent();
    }

    _maxDiscountPerYear = maxDiscountPerYear;

    emit maxDiscountPerYearUpdated(oldMaxDiscountPerYear, maxDiscountPerYear);
  }
}

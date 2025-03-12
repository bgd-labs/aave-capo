// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IPendlePriceCapAdapter, ICLSynchronicityPriceAdapter, IACLManager, IChainlinkAggregator} from '../interfaces/IPendlePriceCapAdapter.sol';
import {IPendlePrincipalToken} from '../interfaces/IPendlePrincipalToken.sol';

/**
 * @title PendlePriceCapAdapter
 * @author BGD Labs
 * @notice Price adapter to cap the price of the PT-tokens.
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

  constructor(
    address assetToUsdAggregator_,
    address pendlePrincipalToken_,
    uint16 maxDiscountPerYear_,
    address aclManager_,
    string memory description_
  ) {
    if (
      assetToUsdAggregator_ == address(0) ||
      pendlePrincipalToken_ == address(0) ||
      aclManager_ == address(0)
    ) {
      revert ZeroAddress();
    }

    ACL_MANAGER = IACLManager(aclManager_);

    ASSET_TO_USD_AGGREGATOR = IChainlinkAggregator(assetToUsdAggregator_);
    DECIMALS = ASSET_TO_USD_AGGREGATOR.decimals();

    PENDLE_PRINCIPAL_TOKEN = IPendlePrincipalToken(pendlePrincipalToken_);
    MATURITY = PENDLE_PRINCIPAL_TOKEN.expiry();

    if (MATURITY <= block.timestamp) {
      revert MaturityHasAlreadyPassed();
    }

    _description = description_;

    _setMaxDiscountPerYear(maxDiscountPerYear_);
  }

  /// @inheritdoc IPendlePriceCapAdapter
  function setMaxDiscountPerYear(uint16 maxDiscountPerYear_) external {
    if (!ACL_MANAGER.isRiskAdmin(msg.sender) && !ACL_MANAGER.isPoolAdmin(msg.sender)) {
      revert CallerIsNotRiskOrPoolAdmin();
    }

    _setMaxDiscountPerYear(maxDiscountPerYear_);
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

  function _setMaxDiscountPerYear(uint16 maxDiscountPerYear_) internal {
    if (
      ((MATURITY - block.timestamp) * maxDiscountPerYear_) / SECONDS_PER_YEAR > PERCENTAGE_FACTOR
    ) {
      revert DiscountExceeds100Percent();
    }

    _maxDiscountPerYear = maxDiscountPerYear_;
  }
}

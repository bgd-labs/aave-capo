// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {PercentageMath} from 'aave-v3-core/contracts/protocol/libraries/math/PercentageMath.sol';
import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../interfaces/IPriceCapAdapter.sol';

/**
 * @title PriceCapAdapterBase
 * @author BGD Labs
 * @notice Price adapter to cap the price of the underlying asset.
 */
abstract contract PriceCapAdapterBase is IPriceCapAdapter {
  using PercentageMath for uint256;

  /// @inheritdoc IPriceCapAdapter
  uint256 public constant SECONDS_PER_YEAR = 365 days;

  /// @inheritdoc IPriceCapAdapter
  IChainlinkAggregator public immutable BASE_TO_USD;

  /// @inheritdoc IPriceCapAdapter
  IACLManager public immutable ACL_MANAGER;

  /// @inheritdoc IPriceCapAdapter
  uint8 public immutable DECIMALS;

  /// @inheritdoc IPriceCapAdapter
  uint8 public immutable RATIO_DECIMALS;

  /**
   * @notice Description of the pair
   */
  string private _description;

  /**
   * @notice Ratio at the time of snapshot
   */
  uint256 private _snapshotRatio;

  /**
   * @notice Timestamp at the time of snapshot
   */
  uint256 private _snapshotTimestamp;

  /**
   * @notice Ratio growth per second
   */
  uint256 private _maxRatioGrowthPerSecond;

  /**
   * @param baseAggregatorAddress the address of BASE_CURRENCY / USD feed
   * @param pairDescription description
   */
  constructor(
    IACLManager aclManager,
    address baseAggregatorAddress,
    string memory pairDescription,
    uint8 ratioDecimals,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) {
    ACL_MANAGER = aclManager;
    BASE_TO_USD = IChainlinkAggregator(baseAggregatorAddress);
    DECIMALS = BASE_TO_USD.decimals();
    RATIO_DECIMALS = ratioDecimals;

    _description = pairDescription;

    _setCapParameters(snapshotRatio, snapshotTimestamp, maxYearlyRatioGrowthPercent);
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function description() external view returns (string memory) {
    return _description;
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function decimals() external view returns (uint8) {
    return DECIMALS;
  }

  /// @inheritdoc IPriceCapAdapter
  function getSnapshotRatio() external view returns (uint256) {
    return _snapshotRatio;
  }

  /// @inheritdoc IPriceCapAdapter
  function getSnapshotTimestamp() external view returns (uint256) {
    return _snapshotTimestamp;
  }

  /// @inheritdoc IPriceCapAdapter
  function getMaxYearlyGrowthRatePercent() external view returns (uint256) {
    return _maxRatioGrowthPerSecond * SECONDS_PER_YEAR;
  }

  /// @inheritdoc IPriceCapAdapter
  function setCapParameters(
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) external {
    if (!ACL_MANAGER.isRiskAdmin(msg.sender)) {
      revert CallerIsNotRiskAdmin();
    }

    _setCapParameters(snapshotRatio, snapshotTimestamp, maxYearlyRatioGrowthPercent);
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() external view override returns (int256) {
    // get the current ratio
    int256 currentRatio = _getRatio();

    // calculate the ratio based on snapshot ratio and max growth rate
    int256 maxRatio = int256(
      _snapshotRatio + _maxRatioGrowthPerSecond * (block.timestamp - _snapshotTimestamp)
    );

    if (maxRatio < currentRatio) {
      currentRatio = maxRatio;
    }

    // get the base price
    int256 basePrice = BASE_TO_USD.latestAnswer();

    // calculate the price of the underlying asset
    int256 price = (basePrice * currentRatio) / int256(10 ** RATIO_DECIMALS);

    return price;
  }

  function _setCapParameters(
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) internal {
    if (snapshotRatio == 0) {
      revert SnapshotRatioIsZero();
    }
    _snapshotRatio = snapshotRatio;
    _snapshotTimestamp = snapshotTimestamp;

    _maxRatioGrowthPerSecond =
      (_snapshotRatio.percentMul(maxYearlyRatioGrowthPercent)) /
      (SECONDS_PER_YEAR);

    emit CapParametersUpdated(
      snapshotRatio,
      snapshotTimestamp,
      _maxRatioGrowthPerSecond,
      maxYearlyRatioGrowthPercent
    );
  }

  /**
   * @notice Returns the current exchange ratio to the underlying(base) asset
   */
  function _getRatio() internal view virtual returns (int256);
}

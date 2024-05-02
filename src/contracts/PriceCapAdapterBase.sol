// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IPriceCapAdapter, ICLSynchronicityPriceAdapter, IACLManager, IChainlinkAggregator} from '../interfaces/IPriceCapAdapter.sol';

/**
 * @title PriceCapAdapterBase
 * @author BGD Labs
 * @notice Price adapter to cap the price of the underlying asset.
 */
abstract contract PriceCapAdapterBase is IPriceCapAdapter {
  /// @inheritdoc IPriceCapAdapter
  uint256 public constant PERCENTAGE_FACTOR = 1e4;

  /// @inheritdoc IPriceCapAdapter
  uint256 public constant MINIMAL_RATIO_INCREASE_LIFETIME = 3;

  /// @inheritdoc IPriceCapAdapter
  uint256 public constant SECONDS_PER_YEAR = 365 days;

  /// @inheritdoc IPriceCapAdapter
  IChainlinkAggregator public immutable BASE_TO_USD_AGGREGATOR;

  /// @inheritdoc IPriceCapAdapter
  IACLManager public immutable ACL_MANAGER;

  /// @inheritdoc IPriceCapAdapter
  address public immutable RATIO_PROVIDER;

  /// @inheritdoc IPriceCapAdapter
  uint8 public immutable DECIMALS;

  /// @inheritdoc IPriceCapAdapter
  uint8 public immutable RATIO_DECIMALS;

  /// @inheritdoc IPriceCapAdapter
  uint48 public immutable MINIMUM_SNAPSHOT_DELAY;

  /**
   * @notice Description of the pair
   */
  string private _description;

  /**
   * @notice Ratio at the time of snapshot
   */
  uint104 private _snapshotRatio;

  /**
   * @notice Timestamp at the time of snapshot
   */
  uint48 private _snapshotTimestamp;

  /**
   * @notice Ratio growth per second
   */
  uint104 private _maxRatioGrowthPerSecond;

  /**
   * @notice Max yearly growth percent
   */
  uint16 private _maxYearlyRatioGrowthPercent;

  /**
   * @param capAdapterBaseParams parameters to create adapter
   */
  constructor(CapAdapterBaseParams memory capAdapterBaseParams) {
    if (address(capAdapterBaseParams.aclManager) == address(0)) {
      revert ACLManagerIsZeroAddress();
    }
    ACL_MANAGER = capAdapterBaseParams.aclManager;
    BASE_TO_USD_AGGREGATOR = IChainlinkAggregator(capAdapterBaseParams.baseAggregatorAddress);
    RATIO_PROVIDER = capAdapterBaseParams.ratioProviderAddress;
    DECIMALS = BASE_TO_USD_AGGREGATOR.decimals();
    RATIO_DECIMALS = capAdapterBaseParams.ratioDecimals;
    MINIMUM_SNAPSHOT_DELAY = capAdapterBaseParams.minimumSnapshotDelay;

    _description = capAdapterBaseParams.pairDescription;

    _setCapParameters(capAdapterBaseParams.priceCapParams);
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
    return _maxYearlyRatioGrowthPercent;
  }

  /// @inheritdoc IPriceCapAdapter
  function getMaxRatioGrowthPerSecond() external view returns (uint256) {
    return _maxRatioGrowthPerSecond;
  }

  /// @inheritdoc IPriceCapAdapter
  function setCapParameters(PriceCapUpdateParams memory priceCapParams) external {
    if (!ACL_MANAGER.isRiskAdmin(msg.sender) && !ACL_MANAGER.isPoolAdmin(msg.sender)) {
      revert CallerIsNotRiskOrPoolAdmin();
    }

    _setCapParameters(priceCapParams);
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() external view override returns (int256) {
    // get the current lst to underlying ratio
    int256 currentRatio = getRatio();
    // get the base price
    int256 basePrice = BASE_TO_USD_AGGREGATOR.latestAnswer();

    if (basePrice <= 0 || currentRatio <= 0) {
      return 0;
    }

    // calculate the ratio based on snapshot ratio and max growth rate
    int256 maxRatio = _getMaxRatio();

    if (maxRatio < currentRatio) {
      currentRatio = maxRatio;
    }

    // calculate the price of the underlying asset
    int256 price = (basePrice * currentRatio) / int256(10 ** RATIO_DECIMALS);

    return price;
  }

  /**
   * @notice Updates price cap parameters
   * @param priceCapParams parameters to set price cap
   */
  function _setCapParameters(PriceCapUpdateParams memory priceCapParams) internal {
    // if snapshot ratio is 0 then growth will not work as expected
    if (priceCapParams.snapshotRatio == 0) {
      revert SnapshotRatioIsZero();
    }

    // new snapshot timestamp should be gt then stored one, but not gt then timestamp of the current block
    if (
      _snapshotTimestamp >= priceCapParams.snapshotTimestamp ||
      priceCapParams.snapshotTimestamp > block.timestamp - MINIMUM_SNAPSHOT_DELAY
    ) {
      revert InvalidRatioTimestamp(priceCapParams.snapshotTimestamp);
    }
    _snapshotRatio = priceCapParams.snapshotRatio;
    _snapshotTimestamp = priceCapParams.snapshotTimestamp;
    _maxYearlyRatioGrowthPercent = priceCapParams.maxYearlyRatioGrowthPercent;

    _maxRatioGrowthPerSecond = uint104(
      (uint256(priceCapParams.snapshotRatio) * priceCapParams.maxYearlyRatioGrowthPercent) /
        PERCENTAGE_FACTOR /
        SECONDS_PER_YEAR
    );

    // if the ratio on the current growth speed can overflow less then in a MINIMAL_RATIO_INCREASE_LIFETIME years, revert
    if (
      uint256(_snapshotRatio) +
        (_maxRatioGrowthPerSecond * SECONDS_PER_YEAR * MINIMAL_RATIO_INCREASE_LIFETIME) >
      type(uint104).max
    ) {
      revert SnapshotMayOverflowSoon(
        priceCapParams.snapshotRatio,
        priceCapParams.maxYearlyRatioGrowthPercent
      );
    }

    emit CapParametersUpdated(
      priceCapParams.snapshotRatio,
      priceCapParams.snapshotTimestamp,
      _maxRatioGrowthPerSecond,
      priceCapParams.maxYearlyRatioGrowthPercent
    );
  }

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view virtual returns (int256);

  /// @inheritdoc IPriceCapAdapter
  function isCapped() public view returns (bool) {
    // get the current lst to underlying ratio
    int256 currentRatio = getRatio();

    // calculate the ratio based on snapshot ratio and max growth rate
    int256 maxRatio = _getMaxRatio();

    return currentRatio > maxRatio;
  }

  function _getMaxRatio() internal view returns (int256) {
    return
      int256(_snapshotRatio + _maxRatioGrowthPerSecond * (block.timestamp - _snapshotTimestamp));
  }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {ICLSynchronicityPriceAdapter} from 'cl-synchronicity-price-adapter/interfaces/ICLSynchronicityPriceAdapter.sol';
import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';

interface IPriceCapAdapter is ICLSynchronicityPriceAdapter {
  /**
   * @dev Emitted when the cap parameters are updated
   * @param snapshotRatio The ratio at the time of snapshot
   * @param snapshotTimestamp The timestamp at the time of snapshot
   * @param maxRatioGrowthPerSecond Max ratio growth per second
   * @param maxYearlyRatioGrowthPercent Max yearly ratio growth percent
   **/
  event CapParametersUpdated(
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint256 maxRatioGrowthPerSecond,
    uint16 maxYearlyRatioGrowthPercent
  );

  /**
   * @notice Updates price cap parameters
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  function setCapParameters(
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) external;

  /**
   * @notice Number of seconds per year (365 days)
   */
  function SECONDS_PER_YEAR() external view returns (uint256);

  /**
   * @notice Price feed for (BASE_ASSET / USD) pair
   */
  function BASE_TO_USD_AGGREGATOR() external view returns (IChainlinkAggregator);

  /**
   * @notice Ratio feed for (LST_ASSET / BASE_ASSET) pair
   */
  function RATIO_PROVIDER() external view returns (address);

  /**
   * @notice ACL manager contract
   */
  function ACL_MANAGER() external view returns (IACLManager);

  /**
   * @notice Number of decimals in the output of this price adapter
   */
  function DECIMALS() external view returns (uint8);

  /**
   * @notice Number of decimals for (lst asset / underlying asset) ratio
   */
  function RATIO_DECIMALS() external view returns (uint8);

  /**
   * @notice Returns the current exchange ratio of lst to the underlying(base) asset
   */
  function getRatio() external view returns (int256);

  /**
   * @notice Returns the latest snapshot ratio
   */
  function getSnapshotRatio() external view returns (uint256);

  /**
   * @notice Returns the latest snapshot timestamp
   */
  function getSnapshotTimestamp() external view returns (uint256);

  /**
   * @notice Returns the max yearly ratio growth
   */
  function getMaxYearlyGrowthRatePercent() external view returns (uint256);

  error ACLManagerIsZeroAddress();
  error SnapshotRatioIsZero();
  error InvalidRatioTimestamp(uint48);
  error CallerIsNotRiskAdmin();
}

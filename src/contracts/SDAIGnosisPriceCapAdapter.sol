// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IERC4626} from 'forge-std/interfaces/IERC4626.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title SDAIGnosisPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (sDAI / USD) pair by using
 * @notice Chainlink data feed for (DAI / USD) and (sDAI / DAI) ratio.
 */
contract SDAIGnosisPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param daiToBaseAggregatorAddress the address of (DAI / USD) feed
   * @param sDaiAddress the address of the sDAI, used as the (sDAI / DAI) ratio feed
   * @param pairName name identifier
   * @param rewardsAligningInterval the interval in seconds, used to align rewards distribution, to keep them in sync with the yearly APY
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address daiToBaseAggregatorAddress,
    address sDaiAddress,
    string memory pairName,
    uint48 rewardsAligningInterval,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      daiToBaseAggregatorAddress,
      sDaiAddress,
      pairName,
      IERC4626(sDaiAddress).decimals(),
      rewardsAligningInterval,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IERC4626(RATIO_PROVIDER).convertToAssets(10 ** RATIO_DECIMALS));
  }
}

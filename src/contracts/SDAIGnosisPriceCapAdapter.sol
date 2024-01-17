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
   * @notice sDAI token contract, ratio provider for (sDAI / DAI)
   */
  IERC4626 public immutable sDAI; // TODO: I would better generalise it

  /**
   * @param aclManager ACL manager contract
   * @param daiToBaseAggregatorAddress the address of (DAI / USD) feed
   * @param sDaiAddress the address of the sDAI, the (sDAI / DAI) ratio feed
   * @param pairName name identifier
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address daiToBaseAggregatorAddress,
    address sDaiAddress,
    string memory pairName,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      daiToBaseAggregatorAddress,
      pairName,
      IERC4626(sDaiAddress).decimals(),
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {
    sDAI = IERC4626(sDaiAddress);
  }

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(sDAI.convertToAssets(10 ** RATIO_DECIMALS)); // TODO: not sure that RATIO_DECIMALS used appropriate here
    // TODO: sounds like it's actually asset decimals, or priced unit decimals
  }
}

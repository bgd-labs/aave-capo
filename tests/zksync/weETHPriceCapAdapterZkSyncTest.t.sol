// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {CapAdaptersCodeZkSync} from '../../scripts/DeployZkSync.s.sol';
import {AaveV3ZkSync, AaveV3ZkSyncAssets} from 'aave-address-book/AaveV3ZkSync.sol';

contract weETHPriceCapAdapterZkSyncTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeZkSync.weETHAdapterCode(),
      8,
      ForkParams({network: 'zksync', blockNumber: 47840214}),
      'weETH_ZkSync'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CLRatePriceCapAdapter{salt: 'test'}(capAdapterParams);
  }

  function _capAdapterParams()
    internal
    pure
    override
    returns (IPriceCapAdapter.CapAdapterParams memory)
  {
    return
      IPriceCapAdapter.CapAdapterParams({
        aclManager: AaveV3ZkSync.ACL_MANAGER,
        baseAggregatorAddress: AaveV3ZkSyncAssets.WETH_ORACLE,
        ratioProviderAddress: CapAdaptersCodeZkSync.weETH_eETH_AGGREGATOR,
        pairDescription: 'Capped weETH / eETH(ETH) / USD',
        minimumSnapshotDelay: 7 days,
        priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1_050999130243073606,
          snapshotTimestamp: 1729748180, // 24th of October 2024
          maxYearlyRatioGrowthPercent: 8_75
        })
      });
  }
}

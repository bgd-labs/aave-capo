// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {CapAdaptersCodeZkSync} from '../../scripts/DeployZkSync.s.sol';
import {AaveV3ZkSync} from 'aave-address-book/AaveV3ZkSync.sol';

contract sUSDePriceCapAdapterZkSyncTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeZkSync.sUSDeAdapterCode(),
      8,
      ForkParams({network: 'zksync', blockNumber: 47910214}),
      'sUSDe_ZkSync'
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
        baseAggregatorAddress: CapAdaptersCodeZkSync.USDe_PRICE_FEED,
        ratioProviderAddress: CapAdaptersCodeZkSync.sUSDe_USDe_AGGREGATOR,
        pairDescription: 'Capped sUSDe / USDe / USD',
        minimumSnapshotDelay: 14 days,
        priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1_108087487354065863,
          snapshotTimestamp: 1729101653, // 16th of October 2024
          maxYearlyRatioGrowthPercent: 50_00
        })
      });
  }
}

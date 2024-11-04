// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {PriceCapAdapterStable, IChainlinkAggregator} from '../../src/contracts/PriceCapAdapterStable.sol';
import {CapAdaptersCodeZkSync} from '../../scripts/DeployZkSync.s.sol';
import {AaveV3ZkSync} from 'aave-address-book/AaveV3ZkSync.sol';

contract USDePriceCapAdapterZKSyncTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeZkSync.USDeAdapterCode(),
      10,
      ForkParams({network: 'zksync', blockNumber: 47910214})
    )
  {}

  function _capAdapterParams()
    internal
    pure
    override
    returns (IPriceCapAdapterStable.CapAdapterStableParams memory)
  {
    return
      IPriceCapAdapterStable.CapAdapterStableParams({
        aclManager: AaveV3ZkSync.ACL_MANAGER,
        assetToUsdAggregator: IChainlinkAggregator(CapAdaptersCodeZkSync.USDe_PRICE_FEED),
        adapterDescription: 'Capped USDe / USD',
        priceCap: int256(1.04 * 1e8)
      });
  }
}

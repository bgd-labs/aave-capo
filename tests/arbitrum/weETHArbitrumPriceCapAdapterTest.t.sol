// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';

import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrumWeEth.s.sol';

contract weETHArbitrumPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      address(0),
      CapAdaptersCodeArbitrum.weETHAdapterCode(),
      ForkParams({network: 'arbitrum', blockNumber: 197799635}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 8_75,
        minimumSnapshotDelay: 7 days,
        startBlock: 184050978,
        finishBlock: 197799635,
        delayInBlocks: 2550000, // > 7 days
        step: 1000000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 184050978, finishBlock: 197799635}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Arbitrum.ACL_MANAGER,
        baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
        ratioProviderAddress: CapAdaptersCodeArbitrum.weETH_eETH_AGGREGATOR,
        pairDescription: 'Capped weETH / eETH(ETH) / USD'
      })
    )
  {}

  function test_latestAnswer() public override {}

  function test_latestAnswerRetrospective() public override {}

  function test_cappedLatestAnswer() public override {
    vm.createSelectFork(vm.rpcUrl(forkParams.network), capParams.startBlock);

    // create adapter with initial parameters
    IPriceCapAdapter adapter = createAdapterSimple(
      7 days,
      uint40(block.timestamp - 8 days),
      capParams.maxYearlyRatioGrowthPercent
    );

    skip(1);

    // persist adapter
    vm.makePersistent(address(adapter));

    // roll fork to the finish block
    vm.createSelectFork(vm.rpcUrl(forkParams.network), capParams.finishBlock);

    bool isCapped = adapter.isCapped();

    // compare prices
    assertTrue(isCapped, 'price is not capped');

    vm.revokePersistent(address(adapter));
    vm.createSelectFork(vm.rpcUrl(forkParams.network), capParams.finishBlock);
  }
}

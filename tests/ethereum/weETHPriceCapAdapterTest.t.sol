// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {WeETHPriceCapAdapter, IWeEth} from '../../src/contracts/WeETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereumWeEth.s.sol';

contract weETHPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      address(0),
      CapAdaptersCodeEthereum.weETHAdapterCode(),
      ForkParams({network: 'mainnet', blockNumber: 19575450}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 8_75,
        minimumSnapshotDelay: 7 days,
        startBlock: 18061286,
        finishBlock: 19368742,
        delayInBlocks: 50200,
        step: 20000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 19183379, finishBlock: 19575450})
    )
  {}

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public override returns (IPriceCapAdapter) {
    return
      new WeETHPriceCapAdapter(
        aclManager,
        baseAggregatorAddress,
        ratioProviderAddress,
        pairDescription,
        minimumSnapshotDelay,
        priceCapParams
      );
  }

  function createAdapterSimple(
    uint48 minimumSnapshotDelay,
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      createAdapter(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.WETH_ORACLE,
        CapAdaptersCodeEthereum.weETH,
        'weETH / eETH (ETH) / USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(IWeEth(CapAdaptersCodeEthereum.weETH).getRate());
  }

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

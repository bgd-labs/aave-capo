// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseTest.sol';

import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {SAvaxPriceCapAdapter, ISAvax} from '../src/contracts/SAvaxPriceCapAdapter.sol';

contract SAvaxPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      AaveV3AvalancheAssets.sAVAX_ORACLE,
      // TODO: SET, currently just mock
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_10,
        minimumSnapshotDelay: 7 days,
        startBlock: 18061286,
        finishBlock: 19183379,
        delayInBlocks: 200000,
        step: 50000
      })
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
      new SAvaxPriceCapAdapter(
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
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3AvalancheAssets.WAVAX_ORACLE,
        AaveV3AvalancheAssets.sAVAX_UNDERLYING,
        'sAvax / Avax / USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(ISAvax(AaveV3AvalancheAssets.sAVAX_UNDERLYING).getPooledAvaxByShares(10 ** 18));
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 40555293);
  }
}

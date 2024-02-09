// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {BaseAggregatorsBase} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';
import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';

contract WstETHBasePriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      AaveV3BaseAssets.wstETH_ORACLE,
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 8_72,
        minimumSnapshotDelay: 7 days,
        startBlock: 7846275,
        finishBlock: 10346241,
        delayInBlocks: 308000, // 7 days
        step: 308000
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
      new CLRatePriceCapAdapter(
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
        AaveV3Base.ACL_MANAGER,
        AaveV3BaseAssets.WETH_ORACLE,
        BaseAggregatorsBase.WSTETH_STETH_AGGREGATOR,
        'Capped wstETH / stETH(ETH) / USD', // TODO: is it actually going to STETH, but then using ETH feed
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return
      uint104(
        uint256(IChainlinkAggregator(BaseAggregatorsBase.WSTETH_STETH_AGGREGATOR).latestAnswer())
      );
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('base'), 10346240);
  }
}

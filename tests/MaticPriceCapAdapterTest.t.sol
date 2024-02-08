// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseTest.sol';

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {BaseAggregatorsPolygon} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {MaticPriceCapAdapter, IMaticRateProvider} from '../src/contracts/MaticPriceCapAdapter.sol';

abstract contract BaseMaticPriceCapAdapterTest is BaseTest {
  address public immutable RATE_PROVIDER;
  string internal _pairName;

  constructor(
    address notCappedAdapter,
    address rateProvider,
    string memory pairName,
    RetrospectionParams memory retrospectionParams
  ) BaseTest(notCappedAdapter, retrospectionParams) {
    RATE_PROVIDER = rateProvider;
    _pairName = pairName;
  }

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public override returns (IPriceCapAdapter) {
    return
      new MaticPriceCapAdapter(
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
        AaveV3Polygon.ACL_MANAGER,
        BaseAggregatorsPolygon.MATIC_USD_AGGREGATOR,
        RATE_PROVIDER,
        _pairName,
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(IMaticRateProvider(RATE_PROVIDER).getRate());
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 52496345);
  }
}

contract MaticXPriceCapAdapterTest is BaseMaticPriceCapAdapterTest {
  constructor()
    BaseMaticPriceCapAdapterTest(
      AaveV3PolygonAssets.MaticX_ORACLE,
      BaseAggregatorsPolygon.MATICX_RATE_PROVIDER,
      'MaticX / Matic / USD',
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
}

contract StMaticPriceCapAdapterTest is BaseMaticPriceCapAdapterTest {
  constructor()
    BaseMaticPriceCapAdapterTest(
      AaveV3PolygonAssets.stMATIC_ORACLE,
      BaseAggregatorsPolygon.STMATIC_RATE_PROVIDER,
      'stMATIC / Matic / USD',
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
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {MiscPolygon} from 'aave-address-book/MiscPolygon.sol';

import {MaticPriceCapAdapter, IMaticRateProvider} from '../../src/contracts/MaticPriceCapAdapter.sol';

abstract contract BaseMaticPriceCapAdapterTest is BaseTest {
  address public immutable RATE_PROVIDER;
  string internal _pairName;

  constructor(
    address notCappedAdapter,
    address rateProvider,
    string memory pairName,
    RetrospectionParams memory retrospectionParams
  )
    BaseTest(
      notCappedAdapter,
      ForkParams({network: 'polygon', blockNumber: 52496345}),
      retrospectionParams,
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 50808790, finishBlock: 53308720})
    )
  {
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
        AaveV3PolygonAssets.WMATIC_ORACLE,
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
}

contract MaticXPriceCapAdapterTest is BaseMaticPriceCapAdapterTest {
  constructor()
    BaseMaticPriceCapAdapterTest(
      AaveV3PolygonAssets.MaticX_ORACLE,
      MiscPolygon.MaticX_RATE_PROVIDER,
      'MaticX / Matic / USD',
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 10_20,
        minimumSnapshotDelay: 14 days,
        startBlock: 50808790,
        finishBlock: 53308720,
        delayInBlocks: 560000, // 14 days
        step: 280000 // ~ 7 days
      })
    )
  {}
}

contract StMaticPriceCapAdapterTest is BaseMaticPriceCapAdapterTest {
  constructor()
    BaseMaticPriceCapAdapterTest(
      AaveV3PolygonAssets.stMATIC_ORACLE,
      MiscPolygon.stMATIC_RATE_PROVIDER,
      'stMATIC / Matic / USD',
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 10_45,
        minimumSnapshotDelay: 14 days,
        startBlock: 50808790,
        finishBlock: 53308720,
        delayInBlocks: 560000, // 14 days
        step: 280000 // ~ 7 days
      })
    )
  {}
}

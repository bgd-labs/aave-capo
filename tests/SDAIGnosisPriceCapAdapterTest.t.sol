// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseTest.sol';

import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';
import {BaseAggregatorsGnosis} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';
import {IERC4626} from 'forge-std/interfaces/IERC4626.sol';

import {SDAIGnosisPriceCapAdapter} from '../src/contracts/SDAIGnosisPriceCapAdapter.sol';

contract SDAIGnosisPriceCapAdapterTest is BaseTest {
  constructor() BaseTest(AaveV3GnosisAssets.sDAI_ORACLE) {}

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      new SDAIGnosisPriceCapAdapter(
        aclManager,
        baseAggregatorAddress,
        ratioProviderAddress,
        pairDescription,
        minimumSnapshotDelay,
        snapshotRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function createAdapterSimple(
    uint48 minimumSnapshotDelay,
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      new SDAIGnosisPriceCapAdapter(
        AaveV3Gnosis.ACL_MANAGER,
        BaseAggregatorsGnosis.DAI_USD_AGGREGATOR,
        AaveV3GnosisAssets.sDAI_UNDERLYING,
        'sDAIGno / DAI / USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(IERC4626(AaveV3GnosisAssets.sDAI_UNDERLYING).convertToAssets(10 ** 18));
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('gnosis'), 32019351);
  }
}

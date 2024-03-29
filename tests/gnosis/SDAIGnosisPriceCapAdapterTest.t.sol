// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';
import {IERC4626} from 'forge-std/interfaces/IERC4626.sol';

import {SDAIGnosisPriceCapAdapter} from '../../src/contracts/SDAIGnosisPriceCapAdapter.sol';
import {CapAdaptersCodeGnosis} from '../../scripts/DeployGnosis.s.sol';

contract SDAIGnosisPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      AaveV3GnosisAssets.sDAI_ORACLE,
      CapAdaptersCodeGnosis.sDAI_ADAPTER_CODE,
      ForkParams({network: 'gnosis', blockNumber: 32776379}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 10_15,
        minimumSnapshotDelay: 7 days,
        startBlock: 31114532,
        finishBlock: 32776379,
        delayInBlocks: 120000, // 7 days
        step: 120000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 31114532, finishBlock: 32364499})
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
      new SDAIGnosisPriceCapAdapter(
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
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.WXDAI_ORACLE,
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
}

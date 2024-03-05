// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';

import {SDAIPriceCapAdapter, IPot} from '../../src/contracts/SDAIPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract SDAIPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      AaveV3EthereumAssets.sDAI_ORACLE,
      CapAdaptersCodeEthereum.sDAI_ADAPTER_CODE,
      ForkParams({network: 'mainnet', blockNumber: 19368742}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 10_15,
        minimumSnapshotDelay: 7 days,
        startBlock: 18061286,
        finishBlock: 19368742,
        delayInBlocks: 50200,
        step: 200000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 18061286, finishBlock: 19183379})
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
      new SDAIPriceCapAdapter(
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
        AaveV3EthereumAssets.DAI_ORACLE,
        MiscEthereum.sDAI_POT,
        'sDAI / DAI / USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(IPot(MiscEthereum.sDAI_POT).chi());
  }
}

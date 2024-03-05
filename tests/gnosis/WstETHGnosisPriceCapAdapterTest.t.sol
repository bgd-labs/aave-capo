// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';
import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeGnosis} from '../../scripts/DeployGnosis.s.sol';

contract WstETHGnosisPriceCapAdapterTest is CLAdapterBaseTest {
  address public constant WSTETH_STETH_AGGREGATOR = 0x0064AC007fF665CF8D0D3Af5E0AD1c26a3f853eA;

  constructor()
    CLAdapterBaseTest(
      AaveV3GnosisAssets.wstETH_ORACLE,
      CapAdaptersCodeGnosis.wstETH_ADAPTER_CODE,
      ForkParams({network: 'gnosis', blockNumber: 32776379}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_68,
        minimumSnapshotDelay: 7 days,
        startBlock: 31114532,
        finishBlock: 32776379,
        delayInBlocks: 120000, // 7 days
        step: 120000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 31114532, finishBlock: 32364499}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Gnosis.ACL_MANAGER,
        baseAggregatorAddress: AaveV3GnosisAssets.WETH_ORACLE,
        ratioProviderAddress: WSTETH_STETH_AGGREGATOR,
        pairDescription: 'Capped wstETH / stETH(ETH) / USD'
      })
    )
  {}
}

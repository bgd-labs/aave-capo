// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {MiscBase} from 'aave-address-book/MiscBase.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';

contract cbETHBasePriceCapAdapterTest is CLAdapterBaseTest {
  address cbETH_ETH_AGGREGATOR = 0x806b4Ac04501c29769051e42783cF04dCE41440b;

  constructor()
    CLAdapterBaseTest(
      AaveV3BaseAssets.cbETH_ORACLE,
      ForkParams({network: 'base', blockNumber: 10346239}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 8_12,
        minimumSnapshotDelay: 7 days,
        startBlock: 7846275,
        finishBlock: 10346241,
        delayInBlocks: 308000, // 7 days
        step: 308000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 1_00, startBlock: 7846275, finishBlock: 10346241}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Base.ACL_MANAGER,
        baseAggregatorAddress: AaveV3BaseAssets.WETH_ORACLE,
        ratioProviderAddress: MiscBase.cbETH_ETH_AGGREGATOR,
        pairDescription: 'Capped cbETH / ETH / USD'
      })
    )
  {}

  function _mockExistingOracleExchangeRate() internal override {
    uint256 cbEthRate = getCurrentRatio();
    vm.mockCall(
      cbETH_ETH_AGGREGATOR,
      abi.encodeWithSelector(ICLSynchronicityPriceAdapter.latestAnswer.selector),
      abi.encode(int256(cbEthRate))
    );
  }
}

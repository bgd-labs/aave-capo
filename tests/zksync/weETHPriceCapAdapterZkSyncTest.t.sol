// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {CapAdaptersCodeZkSync} from '../../scripts/DeployZkSync.s.sol';
import {AaveV3ZkSync, AaveV3ZkSyncAssets} from 'aave-address-book/AaveV3ZkSync.sol';

contract weETHPriceCapAdapterZkSyncTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeZkSync.weETHAdapterParams(),
      8,
      ForkParams({network: 'zksync', blockNumber: 47840214}),
      'weETH_ZkSync'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CLRatePriceCapAdapter{salt: 'test'}(capAdapterParams);
  }

  
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {MiscBase} from 'aave-address-book/MiscBase.sol';

import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract weETHBasePriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeBase.weETHAdapterCode(),
      30,
      ForkParams({network: 'base', blockNumber: 14720247}),
      'weETH_base'
    )
  {}
}

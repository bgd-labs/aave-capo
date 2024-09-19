// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Scroll, AaveV3ScrollAssets} from 'aave-address-book/AaveV3Scroll.sol';
import {MiscScroll} from 'aave-address-book/MiscScroll.sol';

import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeScroll} from '../../scripts/DeployScroll.s.sol';

contract weETHScrollPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeScroll.weETHAdapterCode(),
      30,
      ForkParams({network: 'scroll', blockNumber: 7951074}),
      'weETH_scroll'
    )
  {}
}

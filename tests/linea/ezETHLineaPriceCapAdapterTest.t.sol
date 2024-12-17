// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeLinea} from '../../scripts/DeployLinea.s.sol';

contract ezETHLineaPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeLinea.ezETHAdapterCode(),
      30,
      ForkParams({network: 'linea', blockNumber: 13423434}),
      'ezETH_Linea'
    )
  {}
}

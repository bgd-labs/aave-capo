// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeLinea} from '../../scripts/DeployLinea.s.sol';

contract wrsETHLineaPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeLinea.wrsETHAdapterCode(),
      90,
      ForkParams({network: 'linea', blockNumber: 17346100}),
      'WRsETH_Linea'
    )
  {}
}

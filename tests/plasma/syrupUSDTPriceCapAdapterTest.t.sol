// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodePlasma} from '../../scripts/DeployPlasma.s.sol';

contract SyrupUSDTPriceCapAdapterPlasmaTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodePlasma.syrupUSDTAdapterCode(),
      7,
      ForkParams({network: 'plasma', blockNumber: 3681000}),
      'syrupUSDT_plasma'
    )
  {}
}

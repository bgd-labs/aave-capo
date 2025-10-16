// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodePlasma} from '../../scripts/DeployPlasma.s.sol';

contract wstETHPriceCapAdapterPlasmaTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodePlasma.wstETHAdapterCode(),
      1,
      ForkParams({network: 'plasma', blockNumber: 3527800}),
      'wstETH_plasma'
    )
  {}
}

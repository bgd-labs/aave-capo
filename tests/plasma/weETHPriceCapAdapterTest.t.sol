// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodePlasma} from '../../scripts/DeployPlasma.s.sol';

contract weETHPriceCapAdapterPlasmaTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodePlasma.weETHAdapterCode(),
      30,
      ForkParams({network: 'plasma', blockNumber: 1101555}),
      'weETH_plasma'
    )
  {}
}

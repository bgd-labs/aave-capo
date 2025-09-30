// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodePlasma} from '../../scripts/DeployPlasma.s.sol';

contract wrsETHPlasmaPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodePlasma.wrsETHAdapterCode(),
      5,
      ForkParams({network: 'plasma', blockNumber: 2308169}),
      'WrsETH_Plasma'
    )
  {}
}

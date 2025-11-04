// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';

import {CapAdaptersCodeAvalanche} from '../../scripts/DeployAvalanche.s.sol';

contract wrsETHAvalanchePriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeAvalanche.wrsETHAdapterCode(),
      14,
      ForkParams({network: 'avalanche', blockNumber: 71355400}),
      'WRsETH_Avalanche'
    )
  {}
}

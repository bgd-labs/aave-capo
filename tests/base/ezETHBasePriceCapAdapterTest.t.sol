// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract ezETHBasePriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeBase.ezETHAdapterCode(),
      90,
      ForkParams({network: 'base', blockNumber: 23967401}),
      'ezETH_base'
    )
  {}
}

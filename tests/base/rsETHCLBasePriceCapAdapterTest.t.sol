// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract rsETHCLBasePriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeBase.rsETHCLAdapterCode(),
      90,
      ForkParams({network: 'base', blockNumber: 26640002}),
      'RsETH_CL_Base'
    )
  {}
}

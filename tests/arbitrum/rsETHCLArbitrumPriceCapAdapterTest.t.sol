// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrum.s.sol';

contract rsETHCLArbitrumPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeArbitrum.rsETHCLAdapterCode(),
      90,
      ForkParams({network: 'arbitrum', blockNumber: 308080000}),
      'RsETH_CL_Arbitrum'
    )
  {}
}

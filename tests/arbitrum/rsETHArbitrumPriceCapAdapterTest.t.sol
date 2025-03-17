// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrum.s.sol';

contract rsETHArbitrumPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeArbitrum.rsETHAdapterCode(),
      3,
      ForkParams({network: 'arbitrum', blockNumber: 316605777}),
      'RsETH_Arbitrum'
    )
  {}
}

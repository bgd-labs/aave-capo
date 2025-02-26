// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract sUSDePriceCapAdapterBaseTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeBase.sUSDeAdapterCode(),
      35,
      ForkParams({network: 'base', blockNumber: 26904450}),
      'sUSDe_Base'
    )
  {}
}

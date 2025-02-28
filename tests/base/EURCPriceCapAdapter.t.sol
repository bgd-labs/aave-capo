// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract EURCBasePriceCapAdapterTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeBase.EURCAdapterCode(),
      10,
      ForkParams({network: 'base', blockNumber: 26853575})
    )
  {}
}

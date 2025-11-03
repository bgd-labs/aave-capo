// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {CapAdaptersCodeLinea} from '../../scripts/DeployLinea.s.sol';

contract mUSDLineaPriceCapAdapterTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeLinea.mUSDAdapterCode(),
      10,
      ForkParams({network: 'linea', blockNumber: 25224700})
    )
  {}
}

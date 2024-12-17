// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {CapAdaptersCodeLinea} from '../../scripts/DeployLinea.s.sol';

contract USDCLineaPriceCapAdapterTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeLinea.USDCAdapterCode(),
      10,
      ForkParams({network: 'linea', blockNumber: 13432357})
    )
  {}
}

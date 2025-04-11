// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract RLUSDPriceCapAdapterTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeEthereum.RLUSDAdapterCode(),
      90,
      ForkParams({network: 'mainnet', blockNumber: 22239000})
    )
  {}
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract EURCEthereumPriceCapAdapterTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeEthereum.EURCAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22630524})
    )
  {}
}

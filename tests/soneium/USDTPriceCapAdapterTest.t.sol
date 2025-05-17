// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {PriceCapAdapterStable} from '../../src/contracts/PriceCapAdapterStable.sol';
import {CapAdaptersCodeSoneium} from '../../scripts/DeploySoneium.s.sol';

contract USDTPriceCapAdapterTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeSoneium.USDTAdapterCode(),
      14,
      ForkParams({network: 'soneium', blockNumber: 7177569})
    )
  {}
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {PriceCapAdapterStable} from '../../src/contracts/PriceCapAdapterStable.sol';
import {CapAdaptersCodeZkSync} from '../../scripts/DeployZkSync.s.sol';

contract USDePriceCapAdapterZKSyncTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeZkSync.USDeAdapterParams(),
      10,
      ForkParams({network: 'zksync', blockNumber: 47910214})
    )
  {}
}

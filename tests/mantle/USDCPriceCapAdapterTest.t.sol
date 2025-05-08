// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {CapAdaptersCodeMantle} from '../../scripts/DeployMantle.s.sol';

contract USDCMantlePriceCapAdapterTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeMantle.USDCAdapterCode(),
      10,
      ForkParams({network: 'mantle', blockNumber: 78380776})
    )
  {}
}

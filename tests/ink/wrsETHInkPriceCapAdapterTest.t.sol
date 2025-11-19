// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeInk} from '../../scripts/DeployInk.s.sol';

contract wrsETHInkPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeInk.wrsETHAdapterCode(),
      1,
      ForkParams({network: 'ink', blockNumber: 29965203}),
      'wrsETH_Ink'
    )
  {}
}

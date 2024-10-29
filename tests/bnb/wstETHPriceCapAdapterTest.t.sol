// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CapAdaptersCodeBNB, CLRatePriceCapAdapter} from '../../scripts/DeployBnb.s.sol';

contract wstETHPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeBNB.wstETHAdapterCode(),
      9,
      ForkParams({network: 'bnb', blockNumber: 42738754}),
      'wstETH_BNB'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CLRatePriceCapAdapter(capAdapterParams);
  }
}

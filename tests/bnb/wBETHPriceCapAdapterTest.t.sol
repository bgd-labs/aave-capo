// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CapAdaptersCodeBNB, CLRatePriceCapAdapter} from '../../scripts/DeployBnb.s.sol';
import {WBEthPriceCapAdapter} from '../../src/contracts/lst-adapters/WBEthPriceCapAdapter.sol';

contract wstETHPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeBNB.wBETHAdapterCode(),
      9,
      ForkParams({network: 'bnb', blockNumber: 43552946}),
      'wBETH_BNB'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new WBEthPriceCapAdapter(capAdapterParams);
  }
}

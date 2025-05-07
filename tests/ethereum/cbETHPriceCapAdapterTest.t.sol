// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CbETHPriceCapAdapter} from '../../src/contracts/lst-adapters/CbETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract CbETHPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.cbETHAdapterCode(),
      7,
      ForkParams({network: 'mainnet', blockNumber: 22375088}),
      'cbETH_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CbETHPriceCapAdapter(capAdapterParams);
  }
}

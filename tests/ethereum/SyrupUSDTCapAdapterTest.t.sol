// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {SyrupUSDTPriceCapAdapter} from '../../src/contracts/lst-adapters/SyrupUSDTPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract SyrupUSDTPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.syrupUSDTAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 23697800}),
      'SyrupUSDT_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new SyrupUSDTPriceCapAdapter(capAdapterParams);
  }
}

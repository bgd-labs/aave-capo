// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {EzETHPriceCapAdapter} from '../../src/contracts/lst-adapters/EzETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract ezETHPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.ezETHAdapterCode(),
      90,
      ForkParams({network: 'mainnet', blockNumber: 21019676}),
      'EzETH_EthereumLido'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new EzETHPriceCapAdapter(capAdapterParams);
  }
}

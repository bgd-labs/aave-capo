// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {RsETHL2PriceCapAdapter} from '../../src/contracts/lst-adapters/RsETHL2PriceCapAdapter.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract RsETHBasePriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeBase.rsETHAdapterCode(),
      90,
      ForkParams({network: 'base', blockNumber: 26503333}),
      'RsETH_Base'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new RsETHL2PriceCapAdapter(capAdapterParams);
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {RsETHL2PriceCapAdapter} from '../../src/contracts/lst-adapters/RsETHL2PriceCapAdapter.sol';
import {CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrum.s.sol';

contract RsETHArbitrumPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeArbitrum.rsETHAdapterCode(),
      90,
      ForkParams({network: 'arbitrum', blockNumber: 307001415}),
      'RsETH_Arbitrum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new RsETHL2PriceCapAdapter(capAdapterParams);
  }
}

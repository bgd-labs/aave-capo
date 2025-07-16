// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {LBTCPriceCapAdapter} from '../../src/contracts/lst-adapters/LBTCPriceCapAdapter.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract LBTCPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeBase.lBTCAdapterCode(),
      1,
      ForkParams({network: 'base', blockNumber: 32940903}),
      'LBTC_Base'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new LBTCPriceCapAdapter(capAdapterParams);
  }
}

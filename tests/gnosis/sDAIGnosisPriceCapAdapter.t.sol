// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';
import {sDAIGnosisPriceCapAdapter} from '../../src/contracts/lst-adapters/sDAIGnosisPriceCapAdapter.sol';
import {CapAdaptersCodeGnosis} from '../../scripts/DeployGnosis.s.sol';

contract sDAIGnosisPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeGnosis.sDAIAdapterCode(),
      20,
      ForkParams({network: 'gnosis', blockNumber: 40076139}),
      'sDAI_Gnosis'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new sDAIGnosisPriceCapAdapter(capAdapterParams);
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';
import {OsGNOPriceCapAdapter} from '../../src/contracts/lst-adapters/OsGNOPriceCapAdapter.sol';
import {CapAdaptersCodeGnosis} from '../../scripts/DeployGnosis.s.sol';

contract sDAIGnosisPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeGnosis.osGNOAdapterCode(),
      20,
      ForkParams({network: 'gnosis', blockNumber: 37808523}),
      'osGNO_Gnosis'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new OsGNOPriceCapAdapter(capAdapterParams);
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {CapAdaptersCodePlasma} from '../../scripts/DeployPlasma.s.sol';

contract sUSDePriceCapAdapterPlasmaTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodePlasma.sUSDeAdapterParams(),
      35,
      ForkParams({network: 'plasma', blockNumber: 1172593}),
      'sUSDe_Plasma'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CLRatePriceCapAdapter{salt: 'test'}(capAdapterParams);
  }
}

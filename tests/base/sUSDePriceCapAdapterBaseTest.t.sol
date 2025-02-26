// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract sUSDePriceCapAdapterBaseTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeBase.sUSDeAdapterParams(),
      35,
      ForkParams({network: 'base', blockNumber: 26904449}),
      'sUSDe_Base'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CLRatePriceCapAdapter{salt: 'test'}(capAdapterParams);
  }
}

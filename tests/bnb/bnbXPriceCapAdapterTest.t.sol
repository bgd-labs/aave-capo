// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';

import {BNBxPriceCapAdapter} from '../../src/contracts/lst-adapters/BNBxPriceCapAdapter.sol';
import {CapAdaptersCodeBNB} from '../../scripts/DeployBNB.s.sol';

contract bnbXPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeBNB.BNBxAdapterCode(),
      20,
      ForkParams({network: 'bnb', blockNumber: 41578914}),
      'BNBx_BNB'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new BNBxPriceCapAdapter(capAdapterParams);
  }
}

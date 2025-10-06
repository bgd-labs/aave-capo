// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';

import {SUSDePriceCapAdapter} from '../../src/contracts/lst-adapters/SUSDePriceCapAdapter.sol';
import {CapAdaptersCodeAvalanche} from '../../scripts/DeployAvalanche.s.sol';

contract sUSDePriceCapAdapterAvalancheTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeAvalanche.sUSDeAdapterCode(),
      8,
      ForkParams({network: 'avalanche', blockNumber: 69866570}),
      'sUSDe_Avalanche'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new SUSDePriceCapAdapter(capAdapterParams);
  }
}

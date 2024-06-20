// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {SUSDePriceCapAdapter} from '../../src/contracts/lst-adapters/SUSDePriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

// was tested with USDe / USD feed for a longer period
contract sUSDePriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.sUSDeAdapterCode(),
      8,
      ForkParams({network: 'mainnet', blockNumber: 20131922}),
      'sUSDe_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new SUSDePriceCapAdapter(capAdapterParams);
  }
}

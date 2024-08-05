// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {sFRAXPriceCapAdapter} from '../../src/contracts/lst-adapters/sFRAXPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract sFRAXPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.sFRAXAdapterCode(),
      130, // apy spike was a while ago
      ForkParams({network: 'mainnet', blockNumber: 20460072}),
      'sFRAX_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new sFRAXPriceCapAdapter(capAdapterParams);
  }
}

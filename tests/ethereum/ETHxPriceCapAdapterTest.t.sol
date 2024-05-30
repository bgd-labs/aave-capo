// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {ETHxPriceCapAdapter} from '../../src/contracts/lst-adapters/ETHxPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract ETHxPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.ETHxAdapterCode(),
      90,
      ForkParams({network: 'mainnet', blockNumber: 19984323}),
      'ETHx_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new ETHxPriceCapAdapter(capAdapterParams);
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {RsETHPriceCapAdapter} from '../../src/contracts/lst-adapters/RsETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract RsETHPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumAssets.rsETH_ORACLE,
      CapAdaptersCodeEthereum.rsETHAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22441800}),
      'RsETH_EthereumLido'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new RsETHPriceCapAdapter(capAdapterParams);
  }
}

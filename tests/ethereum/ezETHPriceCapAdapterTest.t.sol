// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';
import {AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';

import {EzETHPriceCapAdapter} from '../../src/contracts/lst-adapters/EzETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract ezETHPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumLidoAssets.ezETH_ORACLE,
      CapAdaptersCodeEthereum.ezETHAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22441800}),
      'EzETH_EthereumLido'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new EzETHPriceCapAdapter(capAdapterParams);
  }
}

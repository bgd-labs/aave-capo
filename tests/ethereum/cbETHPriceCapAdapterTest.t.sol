// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {CbETHPriceCapAdapter} from '../../src/contracts/lst-adapters/CbETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract CbETHPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumAssets.cbETH_ORACLE,
      CapAdaptersCodeEthereum.cbETHAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22441800}),
      'cbETH_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CbETHPriceCapAdapter(capAdapterParams);
  }
}

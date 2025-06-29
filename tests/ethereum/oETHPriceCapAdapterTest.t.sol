// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {OsETHPriceCapAdapter} from '../../src/contracts/lst-adapters/OsETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract osETHPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumAssets.osETH_ORACLE,
      CapAdaptersCodeEthereum.osETHAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22441800}),
      'osETH_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new OsETHPriceCapAdapter(capAdapterParams);
  }
}

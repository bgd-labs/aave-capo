// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {WeETHPriceCapAdapter, IWeEth} from '../../src/contracts/lst-adapters/WeETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract weETHPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumAssets.weETH_ORACLE,
      CapAdaptersCodeEthereum.weETHAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22441800}),
      'weETH_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new WeETHPriceCapAdapter(capAdapterParams);
  }
}

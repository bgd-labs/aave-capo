// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';

import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {WstETHPriceCapAdapter} from '../../src/contracts/lst-adapters/WstETHPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract WstETHSvrPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumAssets.wstETH_ORACLE,
      CapAdaptersCodeEthereum.wstETHAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22418900}),
      'wstETH_svr_comparative'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new WstETHPriceCapAdapter(capAdapterParams);
  }
}

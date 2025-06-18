// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {EthXPriceCapAdapter} from '../../src/contracts/lst-adapters/EthXPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract ethXPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumAssets.ETHx_ORACLE,
      CapAdaptersCodeEthereum.ethXAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22441800}),
      'EthX_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new EthXPriceCapAdapter(capAdapterParams);
  }
}

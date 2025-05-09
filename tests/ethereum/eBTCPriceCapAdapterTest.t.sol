// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTestSvr.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {EBTCPriceCapAdapter} from '../../src/contracts/lst-adapters/EBTCPriceCapAdapter.sol';
import {IEBTC} from '../../src/interfaces/IEBTC.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract EBTCPriceCapAdapterTest is BaseTestSvr {
  constructor()
    BaseTestSvr(
      AaveV3EthereumAssets.eBTC_ORACLE,
      CapAdaptersCodeEthereum.eBTCAdapterCode(),
      30,
      ForkParams({network: 'mainnet', blockNumber: 22441800}),
      'eBTC_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new EBTCPriceCapAdapter(capAdapterParams);
  }

  function _mockRatioProviderRate(uint256 amount) internal override {
    vm.mockCall(
      CapAdaptersCodeEthereum.eBTC_ACCOUNTANT,
      abi.encodeWithSelector(IEBTC.getRate.selector),
      abi.encode(amount)
    );
  }
}

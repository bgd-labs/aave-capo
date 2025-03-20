// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {EBTCPriceCapAdapter} from '../../src/contracts/lst-adapters/EBTCPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract EBTCPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.eBTCAdapterCode(),
      90,
      ForkParams({network: 'mainnet', blockNumber: 22088333}),
      'eBTC_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new EBTCPriceCapAdapter(capAdapterParams);
  }
}

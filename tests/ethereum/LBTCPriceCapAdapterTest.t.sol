// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {LBTCPriceCapAdapter} from '../../src/contracts/lst-adapters/LBTCPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract LBTCPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.lBTCAdapterCode(),
      1,
      ForkParams({network: 'mainnet', blockNumber: 22931650}),
      'LBTC_Ethereum'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new LBTCPriceCapAdapter(capAdapterParams);
  }
}

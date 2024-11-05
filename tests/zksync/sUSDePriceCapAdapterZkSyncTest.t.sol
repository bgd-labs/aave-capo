// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {CapAdaptersCodeZkSync} from '../../scripts/DeployZkSync.s.sol';

contract sUSDePriceCapAdapterZkSyncTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeZkSync.sUSDeAdapterParams(),
      8,
      ForkParams({network: 'zksync', blockNumber: 47910214}),
      'sUSDe_ZkSync'
    )
  {}

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new CLRatePriceCapAdapter{salt: 'test'}(capAdapterParams);
  }
}

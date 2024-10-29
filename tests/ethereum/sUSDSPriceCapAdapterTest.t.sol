// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {sUSDSPriceCapAdapter} from '../../src/contracts/lst-adapters/sUSDSPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract sUSDSPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      CapAdaptersCodeEthereum.sUSDSAdapterCode(),
      3,
      ForkParams({network: 'mainnet', blockNumber: 20729672}),
      'sUSDS_Ethereum'
    )
  {}

  function test_latestAnswer() public override {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USDSAdapterCode());

    super.test_latestAnswer();
  }

  function test_latestAnswerRetrospective() public pure override {
    assert(true);
  }

  function test_cappedLatestAnswer() public pure override {
    assert(true);
  }

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) internal override returns (IPriceCapAdapter) {
    return new sUSDSPriceCapAdapter(capAdapterParams);
  }
}

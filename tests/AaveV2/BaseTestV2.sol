// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {IPriceCapAdapterStable, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapterStable.sol';

abstract contract BaseTestV2 is Test {
  struct ForkParams {
    string network;
    uint256 blockNumber;
  }

  struct AdapterParams {
    bytes[] preRequisiteAdapters;
    bytes adapterCode;
  }

  ForkParams public forkParams;
  AdapterParams public adapterParams;

  ICLSynchronicityPriceAdapter public immutable NOT_CAPPED_ADAPTER;

  constructor(
    address referenceFeed,
    ForkParams memory _forkParams,
    AdapterParams memory _adapterParams
  ) {
    NOT_CAPPED_ADAPTER = ICLSynchronicityPriceAdapter(referenceFeed);

    forkParams = _forkParams;
    adapterParams = _adapterParams;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl(forkParams.network), forkParams.blockNumber);
  }

  function test_latestAnswerRel() public virtual {
    for (uint i = 0; i < adapterParams.preRequisiteAdapters.length; i++) {
      GovV3Helpers.deployDeterministic(adapterParams.preRequisiteAdapters[i]);
    }

    IPriceCapAdapterStable adapter = IPriceCapAdapterStable(
      GovV3Helpers.deployDeterministic(adapterParams.adapterCode)
    );

    int256 price = adapter.latestAnswer();
    int256 priceOfNotCappedAdapter = NOT_CAPPED_ADAPTER.latestAnswer();

    assertApproxEqRel(price, priceOfNotCappedAdapter, 1e16);
  }
}

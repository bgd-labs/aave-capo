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

  struct RetrospectionParams {
    uint256 startBlock;
    uint256 finishBlock;
    uint256 step;
  }

  ForkParams public forkParams;
  AdapterParams public adapterParams;
  RetrospectionParams public retrospectionParams;

  ICLSynchronicityPriceAdapter public immutable NOT_CAPPED_ADAPTER;

  constructor(
    address referenceFeed,
    ForkParams memory _forkParams,
    AdapterParams memory _adapterParams,
    RetrospectionParams memory _retrospectionParams
  ) {
    NOT_CAPPED_ADAPTER = ICLSynchronicityPriceAdapter(referenceFeed);

    forkParams = _forkParams;
    adapterParams = _adapterParams;
    retrospectionParams = _retrospectionParams;
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

    assertApproxEqRel(price, priceOfNotCappedAdapter, 2 * 1e16);
  }

  function test_latestAnswerRetrospectiveRel() public virtual {
    uint256 initialBlock = block.number;

    // start rolling fork and check that the price is the same
    uint256 currentBlock = retrospectionParams.startBlock;

    while (currentBlock <= retrospectionParams.finishBlock) {
      vm.createSelectFork(vm.rpcUrl(forkParams.network), currentBlock);

      for (uint i = 0; i < adapterParams.preRequisiteAdapters.length; i++) {
        GovV3Helpers.deployDeterministic(adapterParams.preRequisiteAdapters[i]);
      }

      IPriceCapAdapterStable adapter = IPriceCapAdapterStable(
        GovV3Helpers.deployDeterministic(adapterParams.adapterCode)
      );

      int256 price = adapter.latestAnswer();
      int256 priceOfNotCappedAdapter = NOT_CAPPED_ADAPTER.latestAnswer();

      assertApproxEqRel(price, priceOfNotCappedAdapter, 2 * 1e16);

      currentBlock += retrospectionParams.step;

      vm.createSelectFork(vm.rpcUrl(forkParams.network), currentBlock);
    }

    vm.createSelectFork(vm.rpcUrl(forkParams.network), initialBlock);
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {IPriceCapAdapterStable, ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapterStable.sol';
import {BlockUtils} from './utils/BlockUtils.sol';

abstract contract BaseStableTest is Test {
  uint256 public constant RETROSPECTIVE_STEP = 3;
  uint256 public immutable RETROSPECTIVE_DAYS;

  struct ForkParams {
    string network;
    uint256 blockNumber;
  }

  ForkParams public forkParams;
  bytes public deploymentCode;

  constructor(
    bytes memory _deploymentCode,
    uint8 _retrospectiveDays,
    ForkParams memory _forkParams
  ) {
    forkParams = _forkParams;
    deploymentCode = _deploymentCode;
    RETROSPECTIVE_DAYS = _retrospectiveDays;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl(forkParams.network), forkParams.blockNumber);
  }

  function test_latestAnswer() public virtual {
    IPriceCapAdapterStable adapter = IPriceCapAdapterStable(
      GovV3Helpers.deployDeterministic(deploymentCode)
    );

    int256 price = adapter.latestAnswer();
    int256 referencePrice = adapter.ASSET_TO_USD_AGGREGATOR().latestAnswer();

    assertFalse(adapter.isCapped());
    assertEq(price, referencePrice);
  }

  function test_latestAnswerRetrospective() public virtual {
    uint256 finishBlock = forkParams.blockNumber;

    // get start block
    uint256 currentBlock = BlockUtils.getStartBlock(
      finishBlock,
      RETROSPECTIVE_DAYS,
      forkParams.network
    );
    vm.createSelectFork(vm.rpcUrl(forkParams.network), currentBlock);

    IPriceCapAdapterStable adapter = IPriceCapAdapterStable(
      GovV3Helpers.deployDeterministic(deploymentCode)
    );

    // persist adapter
    vm.makePersistent(address(adapter));

    // get step
    uint256 step = BlockUtils.getStep(RETROSPECTIVE_STEP, forkParams.network);

    while (currentBlock <= finishBlock) {
      vm.createSelectFork(vm.rpcUrl(forkParams.network), currentBlock);

      int256 price = adapter.latestAnswer();
      int256 referencePrice = adapter.ASSET_TO_USD_AGGREGATOR().latestAnswer();

      assertFalse(adapter.isCapped());
      assertEq(price, referencePrice);

      currentBlock += step;
    }

    vm.revokePersistent(address(adapter));
    vm.createSelectFork(vm.rpcUrl(forkParams.network), finishBlock);
  }
}

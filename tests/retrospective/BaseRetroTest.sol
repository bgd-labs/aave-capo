// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'forge-std/console.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {BaseTest} from '../BaseTest.sol';

abstract contract BaseRetroTest is Test {
  ICLSynchronicityPriceAdapter public immutable NOT_CAPPED_ADAPTER;
  uint16 public immutable MAX_YEARLY_RATIO_GROWTH_PERCENT;
  uint48 public immutable MINIMUM_SNAPSHOT_DELAY;

  uint256 public immutable FINISH_BLOCK;
  uint256 public immutable DELAY_IN_BLOCKS;
  uint256 public immutable STEP;

  constructor(
    address notCappedAdapter,
    uint16 maxYearlyRatioGrowthPercent,
    uint48 minimumSnapshotDelay,
    uint256 finishBlock,
    uint256 delay,
    uint256 step
  ) {
    NOT_CAPPED_ADAPTER = ICLSynchronicityPriceAdapter(notCappedAdapter);
    MAX_YEARLY_RATIO_GROWTH_PERCENT = maxYearlyRatioGrowthPercent;
    MINIMUM_SNAPSHOT_DELAY = minimumSnapshotDelay;

    FINISH_BLOCK = finishBlock;
    DELAY_IN_BLOCKS = delay;
    STEP = step;
  }

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public virtual returns (IPriceCapAdapter);

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public virtual returns (IPriceCapAdapter) {
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams;
    priceCapParams.snapshotRatio = snapshotRatio;
    priceCapParams.snapshotTimestamp = snapshotTimestamp;
    priceCapParams.maxYearlyRatioGrowthPercent = maxYearlyRatioGrowthPercent;

    return
      createAdapter(
        aclManager,
        baseAggregatorAddress,
        ratioProviderAddress,
        pairDescription,
        minimumSnapshotDelay,
        priceCapParams
      );
  }

  function createAdapterSimple(
    uint48 minimumSnapshotDelay,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public virtual returns (IPriceCapAdapter) {
    return
      createAdapterSimple(
        minimumSnapshotDelay,
        getCurrentRatio(),
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function createAdapterSimple(
    uint48 minimumSnapshotDelay,
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public virtual returns (IPriceCapAdapter);

  function setCapParameters(
    IPriceCapAdapter adapter,
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public {
    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );

    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams;
    priceCapParams.snapshotRatio = currentRatio;
    priceCapParams.snapshotTimestamp = snapshotTimestamp;
    priceCapParams.maxYearlyRatioGrowthPercent = maxYearlyRatioGrowthPercent;
    adapter.setCapParameters(priceCapParams);
  }

  function getCurrentRatio() public view virtual returns (uint104);

  function test_latestAnswerRetrospective() public {
    // create adapter with initial parameters
    IPriceCapAdapter adapter = createAdapterSimple(
      MINIMUM_SNAPSHOT_DELAY,
      uint40(block.timestamp - MINIMUM_SNAPSHOT_DELAY),
      MAX_YEARLY_RATIO_GROWTH_PERCENT
    );

    skip(1);

    // persist adapter
    vm.makePersistent(address(adapter));

    uint256 startBlock = block.number;

    require(startBlock < FINISH_BLOCK, 'start block is after finish block');

    // start rolling fork and check that the price is the same
    uint256 currentBlock = startBlock;

    while (currentBlock <= FINISH_BLOCK - DELAY_IN_BLOCKS - STEP) {
      console.log('currentBlock', currentBlock);
      uint48 snapshotTimestamp = uint48(block.timestamp);
      uint104 currentRatio = getCurrentRatio();

      currentBlock += DELAY_IN_BLOCKS;
      vm.rollFork(currentBlock);

      setCapParameters(adapter, currentRatio, snapshotTimestamp, MAX_YEARLY_RATIO_GROWTH_PERCENT);

      int256 price = adapter.latestAnswer();
      int256 priceOfNotCappedAdapter = NOT_CAPPED_ADAPTER.latestAnswer();

      assertEq(
        price,
        priceOfNotCappedAdapter,
        'uncapped price is not equal to the existing adapter price'
      );

      currentBlock += STEP;

      vm.rollFork(currentBlock);
    }
  }
}

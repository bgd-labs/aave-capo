// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

abstract contract BaseTest is Test {
  ICLSynchronicityPriceAdapter public immutable NOT_CAPPED_ADAPTER;

  constructor(address notCappedAdapter) {
    NOT_CAPPED_ADAPTER = ICLSynchronicityPriceAdapter(notCappedAdapter);
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
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams;
    priceCapParams.snapshotRatio = currentRatio;
    priceCapParams.snapshotTimestamp = snapshotTimestamp;
    priceCapParams.maxYearlyRatioGrowthPercent = maxYearlyRatioGrowthPercent;
    adapter.setCapParameters(priceCapParams);
  }

  function getCurrentRatio() public view virtual returns (uint104);

  function deploySimpleAndSetParams(
    uint48 minimumSnapshotDelay,
    uint16 maxYearlyRatioGrowthPercentInitial,
    uint16 maxYearlyRatioGrowthPercentUpdated
  ) public {
    IPriceCapAdapter adapter = createAdapterSimple(
      minimumSnapshotDelay,
      uint48(block.timestamp) - minimumSnapshotDelay,
      maxYearlyRatioGrowthPercentInitial
    );

    skip(1);

    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );
    setCapParameters(
      adapter,
      uint104(adapter.getSnapshotRatio()) + 1,
      uint48(block.timestamp) - minimumSnapshotDelay,
      maxYearlyRatioGrowthPercentUpdated
    );
  }

  function test_constructor(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint104 snapshotRatio,
    uint16 minimumSnapshotDelay,
    uint8 decimals,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public {
    vm.assume(baseAggregatorAddress != 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f);
    vm.assume(address(aclManager) != address(0) && baseAggregatorAddress != address(0));
    vm.assume(snapshotRatio > 0);
    vm.assume(snapshotTimestamp > 0 && snapshotTimestamp <= block.timestamp - minimumSnapshotDelay);

    uint256 maxRatioGrowthInMinimalLifetime = ((uint256(snapshotRatio) *
      maxYearlyRatioGrowthPercent) /
      100_00 /
      365 days) *
      3 *
      365 days;
    vm.assume(snapshotRatio + maxRatioGrowthInMinimalLifetime <= type(uint104).max);

    vm.mockCall(
      baseAggregatorAddress,
      abi.encodeWithSelector(ICLSynchronicityPriceAdapter.decimals.selector),
      abi.encode(decimals)
    );
    IPriceCapAdapter adapter = createAdapter(
      aclManager,
      baseAggregatorAddress,
      ratioProviderAddress,
      pairDescription,
      minimumSnapshotDelay,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    );
    assertEq(address(adapter.ACL_MANAGER()), address(aclManager), 'aclManager not set properly');
    assertEq(
      address(adapter.BASE_TO_USD_AGGREGATOR()),
      baseAggregatorAddress,
      'baseAggregatorAddress not set properly'
    );
    assertEq(
      adapter.RATIO_PROVIDER(),
      ratioProviderAddress,
      'ratioProviderAddress not set properly'
    );
    assertEq(adapter.getSnapshotRatio(), snapshotRatio, 'snapshotRatio not set properly');
    assertEq(adapter.description(), pairDescription, 'pairDescription not set properly');
    assertEq(adapter.decimals(), decimals, 'decimals not set properly');
    assertEq(
      adapter.getSnapshotTimestamp(),
      snapshotTimestamp,
      'snapshotTimestamp not set properly'
    );
    assertEq(
      adapter.getMaxRatioGrowthPerSecond(),
      (uint256(snapshotRatio) * maxYearlyRatioGrowthPercent) / 100_00 / 365 days,
      'getMaxRatioGrowthPerSecond not set properly'
    );
    assertEq(
      adapter.getMaxYearlyGrowthRatePercent(),
      maxYearlyRatioGrowthPercent,
      'maxYearlyRatioGrowthPercent not set properly'
    );
  }

  function test_setParams(
    uint16 minimumSnapshotDelay,
    uint16 maxYearlyRatioGrowthPercentInitial,
    uint16 maxYearlyRatioGrowthPercentUpdated
  ) public {
    vm.assume(block.timestamp > minimumSnapshotDelay);

    IPriceCapAdapter adapter = createAdapterSimple(
      minimumSnapshotDelay,
      uint48(block.timestamp) - minimumSnapshotDelay,
      maxYearlyRatioGrowthPercentInitial
    );

    skip(1);

    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );
    setCapParameters(
      adapter,
      uint104(adapter.getSnapshotRatio()) + 1,
      uint48(block.timestamp) - minimumSnapshotDelay,
      maxYearlyRatioGrowthPercentUpdated
    );
  }

  function test_revert_constructor_timestamp_gt_aligning_interval(
    uint16 minimumSnapshotDelay,
    uint16 maxYearlyRatioGrowthPercentInitial,
    uint48 timestamp
  ) public {
    vm.assume(timestamp > block.timestamp - minimumSnapshotDelay);

    uint104 currentRatio = getCurrentRatio();
    vm.expectRevert(
      abi.encodeWithSelector(IPriceCapAdapter.InvalidRatioTimestamp.selector, timestamp)
    );
    createAdapterSimple(
      minimumSnapshotDelay,
      currentRatio,
      timestamp,
      maxYearlyRatioGrowthPercentInitial
    );
  }

  function test_revert_setParams_timestamp_lt_existing_timestamp(
    uint16 minimumSnapshotDelay,
    uint48 timestamp,
    uint48 timestampUpdate
  ) public {
    vm.assume(block.timestamp > minimumSnapshotDelay);
    vm.assume(timestamp <= block.timestamp - minimumSnapshotDelay);
    vm.assume(timestampUpdate < timestamp);

    IPriceCapAdapter adapter = createAdapterSimple(minimumSnapshotDelay, 1, timestamp, 1);

    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );
    vm.expectRevert(
      abi.encodeWithSelector(IPriceCapAdapter.InvalidRatioTimestamp.selector, timestampUpdate)
    );
    setCapParameters(adapter, 1, timestampUpdate, 1);
  }

  function test_revert_constructor_current_ratio_is_0(
    uint16 maxYearlyRatioGrowthPercentInitial,
    uint48 timestamp
  ) public {
    vm.assume(timestamp < block.timestamp);

    vm.expectRevert(abi.encodeWithSelector(IPriceCapAdapter.SnapshotRatioIsZero.selector));
    createAdapterSimple(0, 0, timestamp, maxYearlyRatioGrowthPercentInitial);
  }

  function test_revert_updateParams_by_not_risk_or_pool_admin() public {
    IPriceCapAdapter adapter = createAdapterSimple(1, 1, 1);
    address aclManager = address(adapter.ACL_MANAGER());

    vm.mockCall(
      aclManager,
      abi.encodeWithSelector(BasicIACLManager.isPoolAdmin.selector),
      abi.encode(false)
    );
    vm.mockCall(
      aclManager,
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(false)
    );
    vm.expectRevert(IPriceCapAdapter.CallerIsNotRiskOrPoolAdmin.selector);
    setCapParameters(adapter, 1, 1, 1);
  }

  function test_latestAnswer(uint16 maxYearlyRatioGrowthPercent) public virtual {
    IPriceCapAdapter adapter = createAdapterSimple(
      0,
      uint40(block.timestamp),
      maxYearlyRatioGrowthPercent
    );

    int256 price = adapter.latestAnswer();
    int256 priceOfNotCappedAdapter = NOT_CAPPED_ADAPTER.latestAnswer();

    assertEq(
      price,
      priceOfNotCappedAdapter,
      'uncapped price is not equal to the existing adapter price'
    );
  }
}

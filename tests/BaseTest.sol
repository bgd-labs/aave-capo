// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

abstract contract BaseTest is Test {
  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public virtual returns (IPriceCapAdapter);

  function createAdapterSimple(
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public virtual returns (IPriceCapAdapter);

  function getCurrentRatio() public view virtual returns (uint104);

  function getCurrentNotCappedPrice() public view virtual returns (int256);

  function deploySimpleAndSetParams(
    uint16 maxYearlyRatioGrowthPercentInitial,
    uint16 maxYearlyRatioGrowthPercentUpdated
  ) public {
    IPriceCapAdapter adapter = createAdapterSimple(
      uint48(block.timestamp),
      maxYearlyRatioGrowthPercentInitial
    );

    skip(1);

    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );
    adapter.setCapParameters(
      uint104(adapter.getSnapshotRatio()) + 1,
      uint48(block.timestamp),
      maxYearlyRatioGrowthPercentUpdated
    );
  }

  function test_constructorParams(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint104 snapshotRatio,
    uint8 decimals,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public {
    //    address baseAggregatorAddress = 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f;
    vm.assume(address(aclManager) != address(0) && baseAggregatorAddress != address(0));
    vm.assume(snapshotRatio > 0);
    vm.assume(snapshotTimestamp > 0 && snapshotTimestamp <= block.timestamp);

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
    uint16 maxYearlyRatioGrowthPercentInitial,
    uint16 maxYearlyRatioGrowthPercentUpdated
  ) public {
    IPriceCapAdapter adapter = createAdapterSimple(
      uint48(block.timestamp),
      maxYearlyRatioGrowthPercentInitial
    );

    skip(1);

    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );
    adapter.setCapParameters(
      uint104(adapter.getSnapshotRatio()) + 1,
      uint48(block.timestamp),
      maxYearlyRatioGrowthPercentUpdated
    );
  }

  function test_latestAnswer(uint16 maxYearlyRatioGrowthPercent) public {
    IPriceCapAdapter adapter = createAdapterSimple(
      uint40(block.timestamp),
      maxYearlyRatioGrowthPercent
    );

    int256 price = adapter.latestAnswer();
    int256 priceOfNotCappedAdapter = getCurrentNotCappedPrice();

    assertEq(price, priceOfNotCappedAdapter);
  }
}

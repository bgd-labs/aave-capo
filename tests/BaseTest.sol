// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {IACLManager} from 'aave-address-book/AaveV3.sol';
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
    vm.assume(address(aclManager) != address(0));
    vm.assume(snapshotRatio > 1e18);
    vm.assume(snapshotTimestamp > 0 && snapshotTimestamp < block.timestamp);

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
    assertEq(address(adapter.ACL_MANAGER()), address(aclManager));
    assertEq(address(adapter.BASE_TO_USD_AGGREGATOR()), baseAggregatorAddress);
    assertEq(adapter.RATIO_PROVIDER(), ratioProviderAddress);
    assertEq(adapter.getSnapshotRatio(), snapshotRatio);
    assertEq(adapter.description(), pairDescription);
    assertEq(adapter.decimals(), decimals);
    assertEq(adapter.getSnapshotTimestamp(), snapshotTimestamp);
    assertEq(adapter.getMaxYearlyGrowthRatePercent(), maxYearlyRatioGrowthPercent);
  }

  function test_latestAnswer(uint16 maxGrowth) public {
    IPriceCapAdapter adapter = createAdapterSimple(uint40(block.timestamp), maxGrowth);

    int256 price = adapter.latestAnswer();
    int256 priceOfNotCappedAdapter = getCurrentNotCappedPrice();

    assertEq(price, priceOfNotCappedAdapter);
  }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';

import './BaseTest.sol';
import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';

abstract contract CLAdapterBaseTest is BaseTest {
  struct AdapterCreationDefaultParams {
    IACLManager aclManager;
    address baseAggregatorAddress;
    address ratioProviderAddress;
    string pairDescription;
  }

  AdapterCreationDefaultParams public adapterDefaults;

  constructor(
    address notCappedAdapter,
    ForkParams memory forkParams,
    // needed for retrospection testing
    RetrospectionParams memory _retrospectionParams,
    CapParams memory _capParams,
    AdapterCreationDefaultParams memory _adapterDefaults
  ) BaseTest(notCappedAdapter, forkParams, _retrospectionParams, _capParams) {
    adapterDefaults = _adapterDefaults;
  }

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public override returns (IPriceCapAdapter) {
    return
      new CLRatePriceCapAdapter(
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
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      createAdapter(
        adapterDefaults.aclManager,
        adapterDefaults.baseAggregatorAddress,
        adapterDefaults.ratioProviderAddress,
        adapterDefaults.pairDescription,
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return
      uint104(uint256(IChainlinkAggregator(adapterDefaults.ratioProviderAddress).latestAnswer()));
  }
}

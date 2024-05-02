// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';
import {PriceCapAdapterBase} from '../src/contracts/PriceCapAdapterBase.sol';

contract TestAdapter is PriceCapAdapterBase {
  constructor(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  )
    PriceCapAdapterBase(
      IPriceCapAdapter.CapAdapterBaseParams({
        aclManager: capAdapterParams.aclManager,
        baseAggregatorAddress: capAdapterParams.baseAggregatorAddress,
        ratioProviderAddress: capAdapterParams.ratioProviderAddress,
        pairDescription: capAdapterParams.pairDescription,
        ratioDecimals: 18,
        minimumSnapshotDelay: capAdapterParams.minimumSnapshotDelay,
        priceCapParams: capAdapterParams.priceCapParams
      })
    )
  {}

  function getRatio() public pure override returns (int256) {
    return 1e18;
  }
}

contract PriceCapAdapterBaseTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19575450);
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
    vm.assume(baseAggregatorAddress != 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    vm.assume(baseAggregatorAddress != 0x000000000000000000636F6e736F6c652e6c6f67);

    vm.assume(ratioProviderAddress != 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f);
    vm.assume(ratioProviderAddress != 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    vm.assume(ratioProviderAddress != 0x000000000000000000636F6e736F6c652e6c6f67);

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

    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams;
    priceCapParams.snapshotRatio = snapshotRatio;
    priceCapParams.snapshotTimestamp = snapshotTimestamp;
    priceCapParams.maxYearlyRatioGrowthPercent = maxYearlyRatioGrowthPercent;

    vm.mockCall(
      baseAggregatorAddress,
      abi.encodeWithSelector(ICLSynchronicityPriceAdapter.decimals.selector),
      abi.encode(decimals)
    );

    vm.mockCall(
      ratioProviderAddress,
      abi.encodeWithSelector(ICLSynchronicityPriceAdapter.decimals.selector),
      abi.encode(decimals)
    );

    IPriceCapAdapter adapter = _createAdapter(
      IPriceCapAdapter.CapAdapterParams({
        aclManager: aclManager,
        baseAggregatorAddress: baseAggregatorAddress,
        ratioProviderAddress: ratioProviderAddress,
        pairDescription: pairDescription,
        minimumSnapshotDelay: minimumSnapshotDelay,
        priceCapParams: priceCapParams
      })
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

    IPriceCapAdapter adapter = _createAdapterSimple(
      minimumSnapshotDelay,
      uint48(block.timestamp) - minimumSnapshotDelay,
      1e18,
      maxYearlyRatioGrowthPercentInitial
    );

    skip(1);

    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );
    _setCapParameters(
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

    vm.expectRevert(
      abi.encodeWithSelector(IPriceCapAdapter.InvalidRatioTimestamp.selector, timestamp)
    );

    _createAdapterSimple(minimumSnapshotDelay, timestamp, 1e18, maxYearlyRatioGrowthPercentInitial);
  }

  function test_revert_setParams_timestamp_lt_existing_timestamp(
    uint16 minimumSnapshotDelay,
    uint48 timestamp,
    uint48 timestampUpdate
  ) public {
    vm.assume(block.timestamp > minimumSnapshotDelay);
    vm.assume(timestamp <= block.timestamp - minimumSnapshotDelay);
    vm.assume(timestampUpdate < timestamp);

    IPriceCapAdapter adapter = _createAdapterSimple(minimumSnapshotDelay, timestamp, 1e18, 1);

    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );
    vm.expectRevert(
      abi.encodeWithSelector(IPriceCapAdapter.InvalidRatioTimestamp.selector, timestampUpdate)
    );
    _setCapParameters(adapter, 1, timestampUpdate, 1);
  }

  function test_revert_constructor_snapshot_ratio_is_0(
    uint16 maxYearlyRatioGrowthPercentInitial,
    uint48 timestamp
  ) public {
    vm.assume(timestamp < block.timestamp);

    vm.expectRevert(abi.encodeWithSelector(IPriceCapAdapter.SnapshotRatioIsZero.selector));
    _createAdapterSimple(0, timestamp, 0, maxYearlyRatioGrowthPercentInitial);
  }

  function test_revert_updateParams_by_not_risk_or_pool_admin() public {
    IPriceCapAdapter adapter = _createAdapterSimple(1, 1, 1, 1);
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
    _setCapParameters(adapter, 1, 1, 1);
  }

  function test_latestAnswer() public {
    IPriceCapAdapter adapter = _createAdapterSimple(0, uint48(block.timestamp - 1), 1e18, 10_00);

    assertEq(adapter.latestAnswer(), _getNotCappedPrice(), 'latestAnswer is capped');
  }

  function test_latestAnswer_capped() public {
    IPriceCapAdapter adapter = _createAdapterSimple(
      0,
      uint48(block.timestamp - 365 days),
      1e17,
      1_00
    );

    assertLt(adapter.latestAnswer(), _getNotCappedPrice(), 'latestAnswer is not capped');
  }

  function _createAdapter(
    IPriceCapAdapter.CapAdapterParams memory capAdapterParams
  ) private returns (IPriceCapAdapter) {
    return new TestAdapter(capAdapterParams);
  }

  function _createAdapterSimple(
    uint16 minimumSnapshotDelay,
    uint48 snapshotTimestamp,
    uint104 snapshotRatio,
    uint16 maxYearlyRatioGrowthPercent
  ) private returns (IPriceCapAdapter) {
    return
      _createAdapter(
        IPriceCapAdapter.CapAdapterParams({
          aclManager: AaveV3Ethereum.ACL_MANAGER,
          baseAggregatorAddress: AaveV3EthereumAssets.WETH_ORACLE,
          ratioProviderAddress: address(1),
          pairDescription: 'test adapter',
          minimumSnapshotDelay: minimumSnapshotDelay,
          priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
            snapshotRatio: snapshotRatio,
            snapshotTimestamp: snapshotTimestamp,
            maxYearlyRatioGrowthPercent: maxYearlyRatioGrowthPercent
          })
        })
      );
  }

  function _getNotCappedPrice() private view returns (int256) {
    return ICLSynchronicityPriceAdapter(AaveV3EthereumAssets.WETH_ORACLE).latestAnswer();
  }

  function _setCapParameters(
    IPriceCapAdapter adapter,
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) private {
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams;
    priceCapParams.snapshotRatio = currentRatio;
    priceCapParams.snapshotTimestamp = snapshotTimestamp;
    priceCapParams.maxYearlyRatioGrowthPercent = maxYearlyRatioGrowthPercent;
    adapter.setCapParameters(priceCapParams);
  }
}

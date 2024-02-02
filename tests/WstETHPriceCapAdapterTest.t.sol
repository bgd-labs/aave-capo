// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets, IACLManager} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {WstETHPriceCapAdapter, IStETH} from '../src/contracts/WstETHPriceCapAdapter.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

contract WstETHPriceCapAdapterTest is BaseTest {
  constructor() BaseTest(AaveV3EthereumAssets.wstETH_ORACLE) {}

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public override returns (IPriceCapAdapter) {
    return
      new WstETHPriceCapAdapter(
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
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.WETH_ORACLE,
        AaveV2EthereumAssets.stETH_UNDERLYING,
        'wstETH/stETH/USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return
      uint104(
        uint256(IStETH(AaveV2EthereumAssets.stETH_UNDERLYING).getPooledEthByShares(10 ** 18))
      );
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  // TODO: test that setParams func sets params as expected

  function test_cappedLatestAnswer() public {
    IPriceCapAdapter adapter = createAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      AaveV3EthereumAssets.WETH_ORACLE,
      AaveV2EthereumAssets.stETH_UNDERLYING,
      'wstETH/stETH/USD',
      7 days,
      1151642949000000000,
      1703743921,
      2_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      256499500000, // max growth 2%
      100000000
    );
  }

  function test_updateParameters_cappedLatestAnswer() public {
    IPriceCapAdapter adapter = createAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      AaveV3EthereumAssets.WETH_ORACLE,
      AaveV2EthereumAssets.stETH_UNDERLYING,
      'wstETH/stETH/USD',
      7 days,
      1151642949000000000,
      1703743921,
      2_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      256499500000, // max growth 2%
      100000000
    );

    vm.prank(AaveV3Ethereum.CAPS_PLUS_RISK_STEWARD);
    setCapParameters(adapter, 1151642955000000000, 1703743931, 20_00);

    price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      256617830000, // value for selected block
      100000000
    );
  }

  function test_revert_updateParameters_notRiskAdmin(
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public {
    IPriceCapAdapter adapter = createAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      AaveV3EthereumAssets.WETH_ORACLE,
      AaveV2EthereumAssets.stETH_UNDERLYING,
      'wstETH/stETH/USD',
      7 days,
      1151642949000000000,
      1703743921,
      2_00
    );

    // TODO: fuzzing?
    vm.expectRevert(IPriceCapAdapter.CallerIsNotRiskOrPoolAdmin.selector);
    setCapParameters(adapter, snapshotRatio, snapshotTimestamp, maxYearlyRatioGrowthPercent);
  }
}

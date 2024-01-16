// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {WstETHPriceCapAdapter} from '../src/contracts/WstETHPriceCapAdapter.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

contract WstETHPriceCapAdapterTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  function test_latestAnswer() public {
    WstETHPriceCapAdapter adapter = new WstETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.STETH,
      'wstETH/stETH/USD',
      1151642949000000000,
      1703743921,
      5_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      256617830000, // value for selected block
      100000000
    );
  }

  function test_cappedLatestAnswer() public {
    WstETHPriceCapAdapter adapter = new WstETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.STETH,
      'wstETH/stETH/USD',
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
    WstETHPriceCapAdapter adapter = new WstETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.STETH,
      'wstETH/stETH/USD',
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
    adapter.setCapParameters(1151642955000000000, 1703743931, 20_00);

    price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      256617830000, // value for selected block
      100000000
    );
  }

  function test_revert_updateParameters_notRiskAdmin() public {
    WstETHPriceCapAdapter adapter = new WstETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.STETH,
      'wstETH/stETH/USD',
      1151642949000000000,
      1703743921,
      2_00
    );

    vm.expectRevert(bytes('ONLY_RISK_ADMIN'));

    adapter.setCapParameters(1151642949000000000, 1723743921, 20_00);
  }
}

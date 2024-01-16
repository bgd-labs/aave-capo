// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {CbETHPriceCapAdapter} from '../src/contracts/CbETHPriceCapAdapter.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

contract CbETHPriceCapAdapterTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  function test_latestAnswer() public {
    CbETHPriceCapAdapter adapter = new CbETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.CBETH,
      'cbETH / ETH / USD',
      1059523963000000000,
      1703743921,
      5_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      236055990000, // value for selected block
      100000000
    );
  }

  function test_cappedLatestAnswer() public {
    CbETHPriceCapAdapter adapter = new CbETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.CBETH,
      'cbETH / ETH / USD',
      1059523963000000000,
      1703743921,
      2_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      235982310000, // max growth 2%
      100000000
    );
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';
import {RETHPriceCapAdapter} from '../src/contracts/RETHPriceCapAdapter.sol';
import {MissingAssetsMainnet} from '../src/lib/MissingAssetsMainnet.sol';

contract RETHPriceCapAdapterTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  function test_latestAnswer() public {
    RETHPriceCapAdapter adapter = new RETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      MissingAssetsMainnet.RETH,
      'rETH / ETH / USD',
      1093801647000000000,
      1703743921,
      5_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      243682110000, // value for selected block
      100000000
    );
  }

  function test_cappedLatestAnswer() public {
    RETHPriceCapAdapter adapter = new RETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      MissingAssetsMainnet.RETH,
      'rETH / ETH / USD',
      1093801647000000000,
      1703743921,
      2_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      243616800000, // max growth 2%
      100000000
    );
  }
}

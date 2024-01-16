// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {SDAIPriceCapAdapter} from '../src/contracts/SDAIPriceCapAdapter.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

contract SDAIPriceCapAdapterTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  function test_latestAnswer() public {
    SDAIPriceCapAdapter adapter = new SDAIPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.DAI_USD_AGGREGATOR,
      BaseAggregatorsMainnet.SDAI_POT,
      'sDAI / DAI / USD',
      1048947230000000000000000000,
      1703743921,
      5_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      105035394, // value for selected block
      100000000
    );
  }

  function test_cappedLatestAnswer() public {
    SDAIPriceCapAdapter adapter = new SDAIPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.DAI_USD_AGGREGATOR,
      BaseAggregatorsMainnet.SDAI_POT,
      'sDAI / DAI / USD',
      1048947230000000000000000000,
      1703743921,
      1_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      104911324, // max growth 2%
      100000000
    );
  }
}

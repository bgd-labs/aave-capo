// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {FixedPriceAdapter} from '../src/contracts/misc-adapters/FixedPriceAdapter.sol';

contract FixedPriceAdapterTest is Test {
  FixedPriceAdapter fixedPriceAdapter;

  int256 public constant FIXED_PRICE = 1e18;
  uint8 public constant DECIMALS = 8;
  string public DESCRIPTION = 'Fixed USDG / USD';

  function setUp() public {
    fixedPriceAdapter = new FixedPriceAdapter(DECIMALS, FIXED_PRICE, DESCRIPTION);
  }

  function test_latestAnswer() external view {
    assertEq(fixedPriceAdapter.latestAnswer(), FIXED_PRICE);
    assertEq(fixedPriceAdapter.PRICE(), FIXED_PRICE);
  }

  function test_decimals() external view {
    assertEq(fixedPriceAdapter.decimals(), DECIMALS);
    assertEq(fixedPriceAdapter.DECIMALS(), DECIMALS);
  }

  function test_description() external view {
    assertEq(fixedPriceAdapter.description(), DESCRIPTION);
  }
}


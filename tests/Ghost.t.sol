// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {Ghost} from '../src/contracts/Ghost.sol';

contract GhostTest is Test {
  Ghost public ghost;

  function setUp() public {
    ghost = new Ghost();
  }

  function testBoo() public {
    assertEq(ghost.boo(), 'Boo!');
  }
}

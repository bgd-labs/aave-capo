// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IChainlinkAggregator} from '../../../src/interfaces/IPriceCapAdapter.sol';

contract ChainlinkAggregatorMock is IChainlinkAggregator {
  constructor(int256 latestAnswer_) {
    latestAnswer = latestAnswer_;
  }

  int256 public latestAnswer;

  function setLatestAnswer(int256 latestAnswer_) external {
    latestAnswer = latestAnswer_;
  }

  function getAnswer(uint256) external view returns (int256) {
    return latestAnswer;
  }

  function getTimestamp(uint256) external view returns (uint256) {
    return block.timestamp;
  }

  function latestTimestamp() external view returns (uint256) {
    return block.timestamp;
  }

  function latestRound() external pure returns (uint256) {
    return 0;
  }

  function decimals() external pure returns (uint8) {
    return 8;
  }
}

pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

library BlockUtils {
  function getStartBlock(
    uint256 finishBlock,
    uint256 retrospectiveDays,
    string memory network
  ) public pure returns (uint256) {
    return finishBlock - retrospectiveDays * getBlocksPerDayByNetwork(network);
  }

  function getStep(uint256 stepDays, string memory network) public pure returns (uint256) {
    return stepDays * getBlocksPerDayByNetwork(network);
  }

  function getBlocksPerDayByNetwork(string memory network) public pure returns (uint256) {
    if (keccak256(bytes(network)) == keccak256(bytes('mainnet'))) {
      return 7300;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('arbitrum'))) {
      return 340000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('avalanche'))) {
      return 43000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('base'))) {
      return 44000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('bnb'))) {
      return 30000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('optimism'))) {
      return 44000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('polygon'))) {
      return 38000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('scroll'))) {
      return 25500;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('gnosis'))) {
      return 17000;
    }

    return 7300;
  }
}

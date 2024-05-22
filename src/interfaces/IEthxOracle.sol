// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the IEthx interface allowing to get exchange ratio with ETH
interface IEthxOracle {
  struct ExchangeRate {
    /// @notice The block number when the exchange rate was last updated.
    uint256 reportingBlockNumber;
    /// @notice The total balance of Ether (ETH) in the system.
    uint256 totalETHBalance;
    /// @notice The total supply of the liquid staking token (ETHX) in the system.
    uint256 totalETHXSupply;
  }
  /**
   * @return the current exchange ratio of the ETHx to the Eth
   */
  function getExchangeRate() external view returns (ExchangeRate memory);
}

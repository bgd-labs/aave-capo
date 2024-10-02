// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.21;

interface ILRTOracle {
  // errors
  error AssetOracleNotSupported();
  error RSETHPriceExceedsLimit();

  // events
  event AssetPriceOracleUpdate(address indexed asset, address indexed priceOracle);
  event RsETHPriceUpdate(uint256 newPrice);
  event PricePercentageLimitUpdate(uint256 newLimit);

  // methods
  function getAssetPrice(address asset) external view returns (uint256);

  function assetPriceOracle(address asset) external view returns (address);

  function rsETHPrice() external view returns (uint256);
}

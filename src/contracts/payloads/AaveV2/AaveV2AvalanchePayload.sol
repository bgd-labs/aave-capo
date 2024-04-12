// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';

contract AaveV2AvalanchePayload is IProposalGenericExecutor {
  // https://snowtrace.io/address/0x39185f2236A6022b682e8BB93C040d125DA093CF
  address public constant USDT_ADAPTER = 0x39185f2236A6022b682e8BB93C040d125DA093CF;

  // https://snowtrace.io/address/0xD8277249e871BE9A402fa286C2C5ec16046dC512
  address public constant USDC_ADAPTER = 0xD8277249e871BE9A402fa286C2C5ec16046dC512;

  // https://snowtrace.io/address/0xf82da795727633aFA9BB0f1B08A87c0F6A38723f
  address public constant DAIe_ADAPTER = 0xf82da795727633aFA9BB0f1B08A87c0F6A38723f;

  function execute() external {
    address[] memory assets = new address[](3);
    address[] memory sources = new address[](3);

    assets[0] = AaveV2AvalancheAssets.USDTe_UNDERLYING;
    sources[0] = USDT_ADAPTER;

    assets[1] = AaveV2AvalancheAssets.USDCe_UNDERLYING;
    sources[1] = USDC_ADAPTER;

    assets[2] = AaveV2AvalancheAssets.DAIe_UNDERLYING;
    sources[2] = DAIe_ADAPTER;

    AaveV2Avalanche.ORACLE.setAssetSources(assets, sources);
  }
}

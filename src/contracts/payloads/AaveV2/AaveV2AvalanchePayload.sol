// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';

contract AaveV2AvalanchePayload is IProposalGenericExecutor {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daieAdapter;
  }

  address public immutable USDt_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAIe_ADAPTER;

  constructor(Adapters memory adapters) {
    USDt_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAIe_ADAPTER = adapters.daieAdapter;
  }

  function execute() external {
    address[] memory assets = new address[](3);
    address[] memory sources = new address[](3);

    assets[0] = AaveV2AvalancheAssets.USDTe_UNDERLYING;
    sources[0] = USDt_ADAPTER;

    assets[1] = AaveV2AvalancheAssets.USDCe_UNDERLYING;
    sources[1] = USDC_ADAPTER;

    assets[2] = AaveV2AvalancheAssets.DAIe_UNDERLYING;
    sources[2] = DAIe_ADAPTER;

    AaveV2Avalanche.ORACLE.setAssetSources(assets, sources);
  }
}

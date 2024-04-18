// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';

contract AaveV2PolygonPayload is IProposalGenericExecutor {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daiAdapter;
  }

  address public immutable USDT_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAI_ADAPTER;

  constructor(Adapters memory adapters) {
    USDT_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAI_ADAPTER = adapters.daiAdapter;
  }

  function execute() external {
    address[] memory assets = new address[](3);
    address[] memory sources = new address[](3);

    assets[0] = AaveV2PolygonAssets.USDT_UNDERLYING;
    sources[0] = USDT_ADAPTER;

    assets[1] = AaveV2PolygonAssets.USDC_UNDERLYING;
    sources[1] = USDC_ADAPTER;

    assets[2] = AaveV2PolygonAssets.DAI_UNDERLYING;
    sources[2] = DAI_ADAPTER;

    AaveV2Polygon.ORACLE.setAssetSources(assets, sources);
  }
}

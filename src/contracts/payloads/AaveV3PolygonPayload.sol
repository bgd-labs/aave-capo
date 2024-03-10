// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadPolygon, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadPolygon.sol';
import {AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';

contract AaveV3PolygonPayload is AaveV3PayloadPolygon {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daiAdapter;
    address maiAdapter;
    address wstEthAdapter;
    address stMaticAdapter;
    address maticXAdapter;
  }

  address public immutable USDT_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAI_ADAPTER;
  address public immutable MAI_ADAPTER;
  address public immutable wstETH_ADAPTER;
  address public immutable stMATIC_ADAPTER;
  address public immutable MaticX_ADAPTER;

  constructor(Adapters memory adapters) {
    USDT_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAI_ADAPTER = adapters.daiAdapter;
    MAI_ADAPTER = adapters.maiAdapter;
    wstETH_ADAPTER = adapters.wstEthAdapter;
    stMATIC_ADAPTER = adapters.stMaticAdapter;
    MaticX_ADAPTER = adapters.maticXAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](8);
    updates[0].asset = AaveV3PolygonAssets.USDT_UNDERLYING;
    updates[0].priceFeed = USDT_ADAPTER;

    updates[1].asset = AaveV3PolygonAssets.USDCn_UNDERLYING;
    updates[1].priceFeed = USDC_ADAPTER;

    updates[2].asset = AaveV3PolygonAssets.USDC_UNDERLYING;
    updates[2].priceFeed = USDC_ADAPTER;

    updates[3].asset = AaveV3PolygonAssets.DAI_UNDERLYING;
    updates[3].priceFeed = DAI_ADAPTER;

    updates[4].asset = AaveV3PolygonAssets.miMATIC_UNDERLYING;
    updates[4].priceFeed = MAI_ADAPTER;

    updates[5].asset = AaveV3PolygonAssets.wstETH_UNDERLYING;
    updates[5].priceFeed = wstETH_ADAPTER;

    updates[6].asset = AaveV3PolygonAssets.stMATIC_UNDERLYING;
    updates[6].priceFeed = stMATIC_ADAPTER;

    updates[7].asset = AaveV3PolygonAssets.MaticX_UNDERLYING;
    updates[7].priceFeed = MaticX_ADAPTER;

    return updates;
  }
}

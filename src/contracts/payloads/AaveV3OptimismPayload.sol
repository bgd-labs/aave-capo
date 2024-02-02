// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadOptimism, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadOptimism.sol';
import {AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';

contract AaveV3OptimismPayload is AaveV3PayloadOptimism {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daiAdapter;
    address lusdAdapter;
    address sUsdAdapter;
    address rEthAdapter;
    address wstEthAdapter;
  }

  address public immutable USDT_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAI_ADAPTER;
  address public immutable LUSD_ADAPTER;
  address public immutable sUSD_ADAPTER;
  address public immutable rETH_ADAPTER;
  address public immutable wstETH_ADAPTER;

  constructor(Adapters memory adapters) {
    USDT_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAI_ADAPTER = adapters.daiAdapter;
    LUSD_ADAPTER = adapters.lusdAdapter;
    sUSD_ADAPTER = adapters.sUsdAdapter;
    rETH_ADAPTER = adapters.rEthAdapter;
    wstETH_ADAPTER = adapters.wstEthAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](8);
    updates[0].asset = AaveV3OptimismAssets.USDT_UNDERLYING;
    updates[0].priceFeed = USDT_ADAPTER;

    updates[1].asset = AaveV3OptimismAssets.USDCn_UNDERLYING;
    updates[1].priceFeed = USDC_ADAPTER;

    updates[2].asset = AaveV3OptimismAssets.USDC_UNDERLYING;
    updates[2].priceFeed = USDC_ADAPTER;

    updates[3].asset = AaveV3OptimismAssets.DAI_UNDERLYING;
    updates[3].priceFeed = DAI_ADAPTER;

    updates[4].asset = AaveV3OptimismAssets.LUSD_UNDERLYING;
    updates[4].priceFeed = LUSD_ADAPTER;

    updates[5].asset = AaveV3OptimismAssets.sUSD_UNDERLYING;
    updates[5].priceFeed = sUSD_ADAPTER;

    updates[6].asset = AaveV3OptimismAssets.rETH_UNDERLYING;
    updates[6].priceFeed = rETH_ADAPTER;

    updates[7].asset = AaveV3OptimismAssets.wstETH_UNDERLYING;
    updates[7].priceFeed = wstETH_ADAPTER;

    return updates;
  }
}

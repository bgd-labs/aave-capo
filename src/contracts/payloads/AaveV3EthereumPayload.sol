// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadEthereum, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadEthereum.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

contract AaveV3EthereumPayload is AaveV3PayloadEthereum {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daiAdapter;
    address sDaiAdapter;
    address lusdAdapter;
    address fraxAdapter;
    address crvUsdAdapter;
    address cbEthAdapter;
    address rEthAdapter;
    address wstEthAdapter;
  }

  address public immutable USDT_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAI_ADAPTER;
  address public immutable sDAI_ADAPTER;
  address public immutable LUSD_ADAPTER;
  address public immutable FRAX_ADAPTER;
  address public immutable crvUSD_ADAPTER;
  address public immutable cbETH_ADAPTER;
  address public immutable rETH_ADAPTER;
  address public immutable wstETH_ADAPTER;

  constructor(Adapters memory adapters) {
    USDT_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAI_ADAPTER = adapters.daiAdapter;
    sDAI_ADAPTER = adapters.sDaiAdapter;
    LUSD_ADAPTER = adapters.lusdAdapter;
    FRAX_ADAPTER = adapters.fraxAdapter;
    crvUSD_ADAPTER = adapters.crvUsdAdapter;
    cbETH_ADAPTER = adapters.cbEthAdapter;
    rETH_ADAPTER = adapters.rEthAdapter;
    wstETH_ADAPTER = adapters.wstEthAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](10);
    updates[0].asset = AaveV3EthereumAssets.USDT_UNDERLYING;
    updates[0].priceFeed = USDT_ADAPTER;

    updates[1].asset = AaveV3EthereumAssets.USDC_UNDERLYING;
    updates[1].priceFeed = USDC_ADAPTER;

    updates[2].asset = AaveV3EthereumAssets.DAI_UNDERLYING;
    updates[2].priceFeed = DAI_ADAPTER;

    updates[3].asset = AaveV3EthereumAssets.sDAI_UNDERLYING;
    updates[3].priceFeed = sDAI_ADAPTER;

    updates[4].asset = AaveV3EthereumAssets.LUSD_UNDERLYING;
    updates[4].priceFeed = LUSD_ADAPTER;

    updates[5].asset = AaveV3EthereumAssets.FRAX_UNDERLYING;
    updates[5].priceFeed = FRAX_ADAPTER;

    updates[6].asset = AaveV3EthereumAssets.crvUSD_UNDERLYING;
    updates[6].priceFeed = crvUSD_ADAPTER;

    updates[7].asset = AaveV3EthereumAssets.cbETH_UNDERLYING;
    updates[7].priceFeed = cbETH_ADAPTER;

    updates[8].asset = AaveV3EthereumAssets.rETH_UNDERLYING;
    updates[8].priceFeed = rETH_ADAPTER;

    updates[9].asset = AaveV3EthereumAssets.wstETH_UNDERLYING;
    updates[9].priceFeed = wstETH_ADAPTER;

    return updates;
  }
}

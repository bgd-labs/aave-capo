// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadArbitrum, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadArbitrum.sol';
import {AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';

contract AaveV3ArbitrumPayload is AaveV3PayloadArbitrum {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daiAdapter;
    address lusdAdapter;
    address fraxAdapter;
    address maiAdapter;
    address rEthAdapter;
    address wstEthAdapter;
  }

  address public immutable USDT_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAI_ADAPTER;
  address public immutable LUSD_ADAPTER;
  address public immutable FRAX_ADAPTER;
  address public immutable MAI_ADAPTER;
  address public immutable rETH_ADAPTER;
  address public immutable wstETH_ADAPTER;

  constructor(Adapters memory adapters) {
    USDT_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAI_ADAPTER = adapters.daiAdapter;
    LUSD_ADAPTER = adapters.lusdAdapter;
    FRAX_ADAPTER = adapters.fraxAdapter;
    MAI_ADAPTER = adapters.maiAdapter;
    rETH_ADAPTER = adapters.rEthAdapter;
    wstETH_ADAPTER = adapters.wstEthAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](9);
    updates[0].asset = AaveV3ArbitrumAssets.USDT_UNDERLYING;
    updates[0].priceFeed = USDT_ADAPTER;

    updates[1].asset = AaveV3ArbitrumAssets.USDCn_UNDERLYING;
    updates[1].priceFeed = USDC_ADAPTER;

    updates[2].asset = AaveV3ArbitrumAssets.USDC_UNDERLYING;
    updates[2].priceFeed = USDC_ADAPTER;

    updates[3].asset = AaveV3ArbitrumAssets.DAI_UNDERLYING;
    updates[3].priceFeed = DAI_ADAPTER;

    updates[4].asset = AaveV3ArbitrumAssets.LUSD_UNDERLYING;
    updates[4].priceFeed = LUSD_ADAPTER;

    updates[5].asset = AaveV3ArbitrumAssets.FRAX_UNDERLYING;
    updates[5].priceFeed = FRAX_ADAPTER;

    updates[6].asset = AaveV3ArbitrumAssets.MAI_UNDERLYING;
    updates[6].priceFeed = MAI_ADAPTER;

    updates[7].asset = AaveV3ArbitrumAssets.rETH_UNDERLYING;
    updates[7].priceFeed = rETH_ADAPTER;

    updates[8].asset = AaveV3ArbitrumAssets.wstETH_UNDERLYING;
    updates[8].priceFeed = wstETH_ADAPTER;

    return updates;
  }
}

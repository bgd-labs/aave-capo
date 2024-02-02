// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadAvalanche, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadAvalanche.sol';
import {AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';

contract AaveV3AvalanchePayload is AaveV3PayloadAvalanche {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daieAdapter;
    address fraxAdapter;
    address sAvaxAdapter;
  }

  address public immutable USDt_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAIe_ADAPTER;
  address public immutable FRAX_ADAPTER;
  address public immutable sAVAX_ADAPTER;

  constructor(Adapters memory adapters) {
    USDt_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAIe_ADAPTER = adapters.daieAdapter;
    FRAX_ADAPTER = adapters.fraxAdapter;
    sAVAX_ADAPTER = adapters.sAvaxAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](5);
    updates[0].asset = AaveV3AvalancheAssets.USDt_UNDERLYING;
    updates[0].priceFeed = USDt_ADAPTER;

    updates[1].asset = AaveV3AvalancheAssets.USDC_UNDERLYING;
    updates[1].priceFeed = USDC_ADAPTER;

    updates[2].asset = AaveV3AvalancheAssets.DAIe_UNDERLYING;
    updates[2].priceFeed = DAIe_ADAPTER;

    updates[3].asset = AaveV3AvalancheAssets.FRAX_UNDERLYING;
    updates[3].priceFeed = FRAX_ADAPTER;

    updates[4].asset = AaveV3AvalancheAssets.sAVAX_UNDERLYING;
    updates[4].priceFeed = sAVAX_ADAPTER;

    return updates;
  }
}

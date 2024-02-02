// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3PayloadBase, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadBase.sol';
import {AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';

contract AaveV3BasePayload is AaveV3PayloadBase {
  struct Adapters {
    address usdcAdapter;
    address cbEthAdapter;
    address wstEthAdapter;
  }

  address public immutable USDC_ADAPTER;
  address public immutable cbETH_ADAPTER;
  address public immutable wstETH_ADAPTER;

  constructor(Adapters memory adapters) {
    USDC_ADAPTER = adapters.usdcAdapter;
    cbETH_ADAPTER = adapters.cbEthAdapter;
    wstETH_ADAPTER = adapters.wstEthAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](4);
    updates[0].asset = AaveV3BaseAssets.USDbC_UNDERLYING;
    updates[0].priceFeed = USDC_ADAPTER;

    updates[1].asset = AaveV3BaseAssets.USDC_UNDERLYING;
    updates[1].priceFeed = USDC_ADAPTER;

    updates[2].asset = AaveV3BaseAssets.cbETH_UNDERLYING;
    updates[2].priceFeed = cbETH_ADAPTER;

    updates[3].asset = AaveV3BaseAssets.wstETH_UNDERLYING;
    updates[3].priceFeed = wstETH_ADAPTER;

    return updates;
  }
}

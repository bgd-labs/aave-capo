// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadScroll, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadScroll.sol';
import {AaveV3ScrollAssets} from 'aave-address-book/AaveV3Scroll.sol';

contract AaveV3ScrollPayload is AaveV3PayloadScroll {
  struct Adapters {
    address usdcAdapter;
    address wstEthAdapter;
  }

  address public immutable USDC_ADAPTER;
  address public immutable wstETH_ADAPTER;

  constructor(Adapters memory adapters) {
    USDC_ADAPTER = adapters.usdcAdapter;
    wstETH_ADAPTER = adapters.wstEthAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](2);

    updates[0].asset = AaveV3ScrollAssets.USDC_UNDERLYING;
    updates[0].priceFeed = USDC_ADAPTER;

    updates[1].asset = AaveV3ScrollAssets.wstETH_UNDERLYING;
    updates[1].priceFeed = wstETH_ADAPTER;

    return updates;
  }
}

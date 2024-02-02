// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadBnb, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadBnb.sol';
import {AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';

contract AaveV3BnbPayload is AaveV3PayloadBnb {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
  }

  address public immutable USDT_ADAPTER;
  address public immutable USDC_ADAPTER;

  constructor(Adapters memory adapters) {
    USDT_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](3);
    updates[0].asset = AaveV3BNBAssets.USDT_UNDERLYING;
    updates[0].priceFeed = USDT_ADAPTER;

    updates[1].asset = AaveV3BNBAssets.USDC_UNDERLYING;
    updates[1].priceFeed = USDC_ADAPTER;

    return updates;
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadMetis, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadMetis.sol';
import {AaveV3MetisAssets} from 'aave-address-book/AaveV3Metis.sol';

contract AaveV3MetisPayload is AaveV3PayloadMetis {
  struct Adapters {
    address mUsdtAdapter;
    address mUsdcAdapter;
    address mDaiAdapter;
  }

  address public immutable mUSDT_ADAPTER;
  address public immutable mUSDC_ADAPTER;
  address public immutable mDAI_ADAPTER;

  constructor(Adapters memory adapters) {
    mUSDT_ADAPTER = adapters.mUsdtAdapter;
    mUSDC_ADAPTER = adapters.mUsdcAdapter;
    mDAI_ADAPTER = adapters.mDaiAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](3);
    updates[0].asset = AaveV3MetisAssets.mUSDT_UNDERLYING;
    updates[0].priceFeed = mUSDT_ADAPTER;

    updates[1].asset = AaveV3MetisAssets.mUSDC_UNDERLYING;
    updates[1].priceFeed = mUSDC_ADAPTER;

    updates[2].asset = AaveV3MetisAssets.mDAI_UNDERLYING;
    updates[2].priceFeed = mDAI_ADAPTER;

    return updates;
  }
}

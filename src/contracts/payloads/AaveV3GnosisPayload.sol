// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3PayloadGnosis, IEngine} from 'aave-helpers/v3-config-engine/AaveV3PayloadGnosis.sol';
import {AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';

//wstETH, sDAI, xDAI, USDC,
contract AaveV3GnosisPayload is AaveV3PayloadGnosis {
  struct Adapters {
    address usdcAdapter;
    address wxDaiAdapter;
    address wstEthAdapter;
  }

  address public immutable USDC_ADAPTER;
  address public immutable WXDAI_ADAPTER;
  address public immutable wstETH_ADAPTER;

  constructor(Adapters memory adapters) {
    USDC_ADAPTER = adapters.usdcAdapter;
    WXDAI_ADAPTER = adapters.wxDaiAdapter;
    wstETH_ADAPTER = adapters.wstEthAdapter;
  }

  function priceFeedsUpdates() public view override returns (IEngine.PriceFeedUpdate[] memory) {
    IEngine.PriceFeedUpdate[] memory updates = new IEngine.PriceFeedUpdate[](3);
    updates[0].asset = AaveV3GnosisAssets.USDC_UNDERLYING;
    updates[0].priceFeed = USDC_ADAPTER;

    updates[1].asset = AaveV3GnosisAssets.WXDAI_UNDERLYING;
    updates[1].priceFeed = WXDAI_ADAPTER;

    updates[2].asset = AaveV3GnosisAssets.wstETH_UNDERLYING;
    updates[2].priceFeed = wstETH_ADAPTER;

    return updates;
  }
}

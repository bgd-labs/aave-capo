// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter, IACLManager} from 'src/contracts/CLRatePriceCapAdapter.sol';
import {PriceCapAdapterStable, IPriceCapAdapterStable, IChainlinkAggregator} from 'src/contracts/PriceCapAdapterStable.sol';
import {AaveV3ZkSync} from 'aave-address-book/AaveV3ZkSync.sol';

contract DeployWstEthZkSync is Script {
  function run() external {
    vm.startBroadcast();
    new CLRatePriceCapAdapter(
      IPriceCapAdapter.CapAdapterParams({
        aclManager: IACLManager(address(AaveV3ZkSync.ACL_MANAGER)),
        baseAggregatorAddress: 0x6D41d1dc818112880b40e26BD6FD347E41008eDA, // eth-usd feed
        ratioProviderAddress: 0x24a0C9404101A8d7497676BE12F10aEa356bAC28, // wst-stETH exchange rate feed
        pairDescription: 'Capped wstETH / stETH(ETH) / USD',
        minimumSnapshotDelay: 7 days,
        priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1173774471238681571,
          snapshotTimestamp: 40127505, // Jul-27-2024
          maxYearlyRatioGrowthPercent: 9_68
        })
      })
    );
    vm.stopBroadcast();
  }
}

contract DeployUsdcZkSync is Script {
  function run() external {
    vm.startBroadcast();
    new PriceCapAdapterStable(
      IPriceCapAdapterStable.CapAdapterStableParams({
        aclManager: IACLManager(address(AaveV3ZkSync.ACL_MANAGER)),
        assetToUsdAggregator: IChainlinkAggregator(0x1824D297C6d6D311A204495277B63e943C2D376E), // usdc-usd feed
        adapterDescription: 'Capped USDC/USD',
        priceCap: 104000000
      })
    );
    vm.stopBroadcast();
  }
}

contract DeployUsdtZkSync is Script {
  function run() external {
    vm.startBroadcast();
    new PriceCapAdapterStable(
      IPriceCapAdapterStable.CapAdapterStableParams({
        aclManager: IACLManager(address(AaveV3ZkSync.ACL_MANAGER)),
        assetToUsdAggregator: IChainlinkAggregator(0xB615075979AE1836B476F651f1eB79f0Cd3956a9), // usdt-usd feed
        adapterDescription: 'Capped USDT/USD',
        priceCap: 104000000
      })
    );
    vm.stopBroadcast();
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {ZkSyncScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {CLRatePriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3ZkSync, AaveV3ZkSyncAssets} from 'aave-address-book/AaveV3ZkSync.sol';
import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IPriceCapAdapterStable} from '../src/interfaces/IPriceCapAdapterStable.sol';
import {IPriceCapAdapter, IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';

library CapAdaptersCodeZkSync {
  address public constant weETH_eETH_AGGREGATOR = 0x8D3184a992f93729b249407C33F1e78abE0d650e;
  address public constant sUSDe_USDe_AGGREGATOR = 0x97920183c36B022B46D6C14b9dA36c5f31A98C6A;
  address public constant USDe_PRICE_FEED = 0x4899faF0b6c36620168D00e3DbD4CB9361244c4d;

  function weETHAdapterParams() internal pure returns (bytes memory) {
    return
      abi.encode(
        IPriceCapAdapter.CapAdapterParams({
          aclManager: AaveV3ZkSync.ACL_MANAGER,
          baseAggregatorAddress: AaveV3ZkSyncAssets.WETH_ORACLE,
          ratioProviderAddress: weETH_eETH_AGGREGATOR,
          pairDescription: 'Capped weETH / eETH(ETH) / USD',
          minimumSnapshotDelay: 7 days,
          priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
            snapshotRatio: 1_050999130243073606,
            snapshotTimestamp: 1729748180, // 24th of October 2024
            maxYearlyRatioGrowthPercent: 8_75
          })
        })
      );
  }

  function sUSDeAdapterParams() internal pure returns (bytes memory) {
    return
      abi.encode(
        IPriceCapAdapter.CapAdapterParams({
          aclManager: AaveV3ZkSync.ACL_MANAGER,
          baseAggregatorAddress: USDe_PRICE_FEED,
          ratioProviderAddress: sUSDe_USDe_AGGREGATOR,
          pairDescription: 'Capped sUSDe / USDe / USD',
          minimumSnapshotDelay: 14 days,
          priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
            snapshotRatio: 1_108087487354065863,
            snapshotTimestamp: 1729101653, // 16th of October 2024
            maxYearlyRatioGrowthPercent: 50_00
          })
        })
      );
  }

  function USDeAdapterParams() internal pure returns (bytes memory) {
    return
      abi.encode(
        IPriceCapAdapterStable.CapAdapterStableParams({
          aclManager: AaveV3ZkSync.ACL_MANAGER,
          assetToUsdAggregator: IChainlinkAggregator(USDe_PRICE_FEED),
          adapterDescription: 'Capped USDe / USD',
          priceCap: int256(1.04 * 1e8)
        })
      );
  }
}

contract DeployWeEthZkSync is ZkSyncScript {
  function run() external broadcast {
    new CLRatePriceCapAdapter{salt: 'capo'}(
      abi.decode(CapAdaptersCodeZkSync.weETHAdapterParams(), (IPriceCapAdapter.CapAdapterParams))
    );
  }
}

contract DeploySUSDeZkSync is ZkSyncScript {
  function run() external broadcast {
    new CLRatePriceCapAdapter{salt: 'capo'}(
      abi.decode(CapAdaptersCodeZkSync.sUSDeAdapterParams(), (IPriceCapAdapter.CapAdapterParams))
    );
  }
}

contract DeployUSDeZkSync is ZkSyncScript {
  function run() external broadcast {
    new PriceCapAdapterStable{salt: 'capo'}(
      abi.decode(
        CapAdaptersCodeZkSync.USDeAdapterParams(),
        (IPriceCapAdapterStable.CapAdapterStableParams)
      )
    );
  }
}

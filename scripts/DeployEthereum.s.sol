// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IPriceCapAdapter, IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../src/interfaces/IPriceCapAdapterStable.sol';
import {WeETHPriceCapAdapter} from '../src/contracts/lst-adapters/WeETHPriceCapAdapter.sol';
import {OsETHPriceCapAdapter} from '../src/contracts/lst-adapters/OsETHPriceCapAdapter.sol';
import {ETHxPriceCapAdapter} from '../src/contracts/lst-adapters/ETHxPriceCapAdapter.sol';

library CapAdaptersCodeEthereum {
  address public constant weETH = 0xCd5fE23C85820F7B72D0926FC9b05b43E359b7ee;
  address public constant osETH_VAULT_CONTROLLER = 0x2A261e60FB14586B474C208b1B7AC6D0f5000306;
  address public constant USDe_PRICE_FEED = 0xa569d910839Ae8865Da8F8e70FfFb0cBA869F961;
  address public constant ETHX_POOLS_MANAGER = 0xcf5EA1b38380f6aF39068375516Daf40Ed70D299;

  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(WeETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3EthereumAssets.WETH_ORACLE,
            ratioProviderAddress: weETH,
            pairDescription: 'Capped weETH / eETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1034656878645040505,
              snapshotTimestamp: 1711416299, // 26-03-2024
              maxYearlyRatioGrowthPercent: 8_75
            })
          })
        )
      );
  }

  function osETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(OsETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3EthereumAssets.WETH_ORACLE,
            ratioProviderAddress: osETH_VAULT_CONTROLLER,
            pairDescription: 'Capped osETH / ETH / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1014445878439441413,
              snapshotTimestamp: 1713934379, // 24-04-2024
              maxYearlyRatioGrowthPercent: 8_75
            })
          })
        )
      );
  } 

  function ETHxAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(ETHxPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3EthereumAssets.WETH_ORACLE,
            ratioProviderAddress: ETHX_POOLS_MANAGER,
            pairDescription: 'Capped ETHx / ETH / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1029650229444067238,
              snapshotTimestamp:  1715870699, // 16-05-2024
              maxYearlyRatioGrowthPercent: 9_24
            })
          })
        )
      );
  }

  function USDeAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDe_PRICE_FEED),
            adapterDescription: 'Capped USDe / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }
}

contract DeployWeEthEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.weETHAdapterCode());
  }
}

contract DeployOsEthEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.osETHAdapterCode());
  }
}

contract DeployEthxEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.ETHxAdapterCode());
  }
}

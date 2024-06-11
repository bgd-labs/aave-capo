// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ArbitrumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {IPriceCapAdapter, IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../src/interfaces/IPriceCapAdapterStable.sol';

library CapAdaptersCodeArbitrum {
  address public constant weETH_eETH_AGGREGATOR = 0x20bAe7e1De9c596f5F7615aeaa1342Ba99294e12;
  address public constant GHO_USD_AGGREGATOR = 0x3c786e934F23375Ca345C9b8D5aD54838796E8e7;

  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Arbitrum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
            ratioProviderAddress: weETH_eETH_AGGREGATOR,
            pairDescription: 'Capped weETH / eETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1034704981376366213,
              snapshotTimestamp: 1711555350, // 27th of March 2024
              maxYearlyRatioGrowthPercent: 8_75
            })
          })
        )
      );
  }

  function GHOAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Arbitrum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(GHO_USD_AGGREGATOR),
            adapterDescription: 'Capped GHO / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }
}

contract DeployWeEthArbitrum is ArbitrumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeArbitrum.weETHAdapterCode());
  }
}

contract DeployGhoArbitrum is ArbitrumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeArbitrum.GHOAdapterCode());
  }
}


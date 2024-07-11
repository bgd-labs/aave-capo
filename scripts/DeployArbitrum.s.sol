// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ArbitrumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';

import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';

library CapAdaptersCodeArbitrum {
  address public constant weETH_eETH_AGGREGATOR = 0x20bAe7e1De9c596f5F7615aeaa1342Ba99294e12;
  address public constant ETHx_ETH_RATE_AGGREGATOR = 0x1f5C0C2CD2e9Ad1eE475660AF0bBa27aE7d87f5e;

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

  function ETHxAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Arbitrum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
            ratioProviderAddress: ETHx_ETH_RATE_AGGREGATOR,
            pairDescription: 'Capped ETHx / ETH / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1033812175710783086,
              snapshotTimestamp: 1719927925, // 2th of July 2024
              maxYearlyRatioGrowthPercent: 9_24
            })
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

contract DeployEthxArbitrum is ArbitrumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeArbitrum.ETHxAdapterCode());
  }
}

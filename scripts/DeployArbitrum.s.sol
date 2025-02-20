// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ArbitrumScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';

import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';

import {RsETHL2PriceCapAdapter} from '../src/contracts/lst-adapters/RsETHL2PriceCapAdapter.sol';

library CapAdaptersCodeArbitrum {
  address public constant weETH_eETH_AGGREGATOR = 0x20bAe7e1De9c596f5F7615aeaa1342Ba99294e12;
  address public constant ezETH_ETH_AGGREGATOR = 0x989a480b6054389075CBCdC385C18CfB6FC08186;
  address public constant rsETH_LRT_ORACLE = 0x3222d3De5A9a3aB884751828903044CC4ADC627e;
  address public constant rsETH_ETH_AGGREGATOR = 0xb0EA543f9F8d4B818550365d13F66Da747e1476A;


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

  function ezETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Arbitrum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
            ratioProviderAddress: ezETH_ETH_AGGREGATOR,
            pairDescription: 'Capped ezETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1029236690318925590,
              snapshotTimestamp: 1733252366, // 2024-12-03
              maxYearlyRatioGrowthPercent: 10_89
            })
          })
        )
      );
  }

  function rsETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(RsETHL2PriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Arbitrum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
            ratioProviderAddress: rsETH_LRT_ORACLE,
            pairDescription: 'Capped rsETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_035909659684521016,
              snapshotTimestamp: 1738578150, // Feb-03-2025
              maxYearlyRatioGrowthPercent: 9_83
            })
          })
        )
      );
  }

  function rsETHCLAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Arbitrum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
            ratioProviderAddress: rsETH_ETH_AGGREGATOR,
            pairDescription: 'Capped rsETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_030448152284394750,
              snapshotTimestamp: 1738849445, // Feb-06-2025
              maxYearlyRatioGrowthPercent: 9_83
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

contract DeployEzEthArbitrum is ArbitrumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeArbitrum.ezETHAdapterCode());
  }
}

contract DeployRsETHArbitrum is ArbitrumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeArbitrum.rsETHCLAdapterCode());
  }
}

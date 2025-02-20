// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';

import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';

import {RsETHL2PriceCapAdapter} from '../src/contracts/lst-adapters/RsETHL2PriceCapAdapter.sol';

library CapAdaptersCodeBase {
  address public constant weETH_eETH_AGGREGATOR = 0x35e9D7001819Ea3B39Da906aE6b06A62cfe2c181;
  address public constant ezETH_ETH_AGGREGATOR = 0xC4300B7CF0646F0Fe4C5B2ACFCCC4dCA1346f5d8;
  address public constant rsETH_LRT_ORACLE = 0x7781ae9B47FeCaCEAeCc4FcA8d0b6187E3eF9ba7;
  address public constant rsETH_ETH_AGGREGATOR = 0xd7221b10FBBC1e1ba95Fd0B4D031C15f7F365296;

  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Base.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BaseAssets.WETH_ORACLE,
            ratioProviderAddress: weETH_eETH_AGGREGATOR,
            pairDescription: 'Capped weETH / eETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1038264880178601326,
              snapshotTimestamp: 1715620171, // 13th of May 2024
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
            aclManager: AaveV3Base.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BaseAssets.WETH_ORACLE,
            ratioProviderAddress: ezETH_ETH_AGGREGATOR,
            pairDescription: 'Capped ezETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1029613402295302804,
              snapshotTimestamp: 1733389347, // 2024-12-05
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
            aclManager: AaveV3Base.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BaseAssets.WETH_ORACLE,
            ratioProviderAddress: rsETH_LRT_ORACLE,
            pairDescription: 'Capped rsETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1035909659684521016,
              snapshotTimestamp: 1738564013, // Feb-03-2025
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
            aclManager: AaveV3Base.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BaseAssets.WETH_ORACLE,
            ratioProviderAddress: rsETH_ETH_AGGREGATOR,
            pairDescription: 'Capped rsETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_032476592423495500,
              snapshotTimestamp: 1738834947, // Feb-06-2025
              maxYearlyRatioGrowthPercent: 9_83
            })
          })
        )
      );
  }
}

contract DeployWeEthBase is BaseScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBase.weETHAdapterCode());
  }
}

contract DeployEzEthBase is BaseScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBase.ezETHAdapterCode());
  }
}

contract DeployRsETHBase is BaseScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBase.rsETHCLAdapterCode());
  }
}

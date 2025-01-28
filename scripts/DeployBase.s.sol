// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';

import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';

library CapAdaptersCodeBase {
  address public constant weETH_eETH_AGGREGATOR = 0x35e9D7001819Ea3B39Da906aE6b06A62cfe2c181;
  address public constant ezETH_ETH_AGGREGATOR = 0xC4300B7CF0646F0Fe4C5B2ACFCCC4dCA1346f5d8;

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

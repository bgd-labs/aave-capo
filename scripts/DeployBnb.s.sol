// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BNBScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';

import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {BNBxPriceCapAdapter} from '../src/contracts/lst-adapters/BNBxPriceCapAdapter.sol';
import {WBEthPriceCapAdapter} from '../src/contracts/lst-adapters/WBEthPriceCapAdapter.sol';

library CapAdaptersCodeBNB {
  address public constant wstETH_stETH_AGGREGATOR = 0x4c75d01cfa4D998770b399246400a6dc40FB9645;
  address public constant BNBx_STAKE_MANAGER_V2 = 0x3b961e83400D51e6E1AF5c450d3C7d7b80588d28;
  address public constant wBETH = 0xa2E3356610840701BDf5611a53974510Ae27E2e1;

  function wstETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3BNB.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BNBAssets.ETH_ORACLE,
            ratioProviderAddress: wstETH_stETH_AGGREGATOR,
            pairDescription: 'Capped wstETH / stETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1179619475032439052,
              snapshotTimestamp: 1727049059, // Sep-22-2024
              maxYearlyRatioGrowthPercent: 9_68
            })
          })
        )
      );
  }

  function BNBxAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(BNBxPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3BNB.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BNBAssets.WBNB_ORACLE,
            ratioProviderAddress: BNBx_STAKE_MANAGER_V2,
            pairDescription: 'Capped BNBx / BNB / USD',
            minimumSnapshotDelay: 21 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1093544888172635115,
              snapshotTimestamp: 1728396262, // Oct-08-2024
              maxYearlyRatioGrowthPercent: 12_00
	    })
          })
        )
      );
  }

  function wBETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(WBEthPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3BNB.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BNBAssets.ETH_ORACLE,
            ratioProviderAddress: wBETH,
            pairDescription: 'Capped wBETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1052029495043000000,
              snapshotTimestamp: 1728879870, // Oct-15-2024
              maxYearlyRatioGrowthPercent: 8_66
            })
          })
        )
      );
  }
}

contract DeployWstEthBnb is BNBScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBNB.wstETHAdapterCode());
  }
}

contract DeployBNBxBnb is BNBScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBNB.BNBxAdapterCode());
  }
}

contract DeployWBEthBnb is BNBScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBNB.wBETHAdapterCode());
  }
}

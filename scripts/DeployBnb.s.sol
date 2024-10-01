// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BNBScript} from 'aave-helpers/ScriptUtils.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter, IACLManager} from 'src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3BNB} from 'aave-address-book/AaveV3BNB.sol';

library CapAdaptersCodeBNB {
  address public constant ETH_USD_AGGREGATOR = 0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e;
  address public constant wstETH_stETH_AGGREGATOR = 0x4c75d01cfa4D998770b399246400a6dc40FB9645;

  function wstETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: IACLManager(address(AaveV3BNB.ACL_MANAGER)),
            baseAggregatorAddress: ETH_USD_AGGREGATOR,
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
}

contract DeployWstEthBnb is BNBScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBNB.wstETHAdapterCode());
  }
}

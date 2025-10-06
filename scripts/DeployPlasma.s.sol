// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {PlasmaScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Plasma, AaveV3PlasmaAssets} from 'aave-address-book/AaveV3Plasma.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {CLRatePriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {PriceCapAdapterStable, IPriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IPriceCapAdapter, IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {PendlePriceCapAdapter, IPendlePriceCapAdapter} from '../src/contracts/PendlePriceCapAdapter.sol';

library CapAdaptersCodePlasma {
  using SafeCast for uint256;

  address public constant weETH_eETH_AGGREGATOR = 0x00D7d8816E969EA6cA9125c3f5D279f9a6D253f6;
  address public constant sUSDe_USDe_AGGREGATOR = 0x802033dc696B92e5ED5bF68E1750F7Ed3329eabD;
  address public constant wrsETH_ETH_AGGREGATOR = 0xee3d5f65B03fabA5B2bF2eCE893399EA88b18e78;
  address public constant PT_sUSDe_15_JAN_2026 = 0x02FCC4989B4C9D435b7ceD3fE1Ba4CF77BBb5Dd8;
  address public constant PT_USDe_15_JAN_2026 = 0x93B544c330F60A2aa05ceD87aEEffB8D38FD8c9a;

  address public constant WETH_PRICE_FEED = 0x43A7dd2125266c5c4c26EB86cd61241132426Fe7;
  address public constant USDT_PRICE_FEED = 0x70b77FcdbE2293423e41AdD2FB599808396807BC;
  address public constant USDT_CAPO_PRICE_FEED = 0xdBbB0b5DD13E7AC9C56624834ef193df87b022c3;

  function ptSUSDeJanuary2026AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3PlasmaAssets.USDT0_ORACLE,
            pendlePrincipalToken: PT_sUSDe_15_JAN_2026,
            maxDiscountRatePerYear: uint256(36.82e16).toUint64(),
            discountRatePerYear: uint256(8.38e16).toUint64(),
            aclManager: address(AaveV3Plasma.ACL_MANAGER),
            description: 'PT Capped sUSDe USDT/USD linear discount 15JAN2026'
          })
        )
      );
  }

  function ptUSDeJanuary2026AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3PlasmaAssets.USDT0_ORACLE,
            pendlePrincipalToken: PT_USDe_15_JAN_2026,
            maxDiscountRatePerYear: uint256(33.88e16).toUint64(),
            discountRatePerYear: uint256(7.96e16).toUint64(),
            aclManager: address(AaveV3Plasma.ACL_MANAGER),
            description: 'PT Capped USDe USDT/USD linear discount 15JAN2026'
          })
        )
      );
  }

  function sUSDeAdapterParams() internal pure returns (bytes memory) {
    return
      abi.encode(
        IPriceCapAdapter.CapAdapterParams({
          aclManager: AaveV3Plasma.ACL_MANAGER,
          baseAggregatorAddress: USDT_CAPO_PRICE_FEED,
          ratioProviderAddress: sUSDe_USDe_AGGREGATOR,
          pairDescription: 'Capped sUSDe / USDe / USD',
          minimumSnapshotDelay: 14 days,
          priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
            snapshotRatio: 1_193972665854975048,
            snapshotTimestamp: 1756871339, // 3-SEPT-2025
            maxYearlyRatioGrowthPercent: 15_19
          })
        })
      );
  }

  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Plasma.ACL_MANAGER,
            baseAggregatorAddress: WETH_PRICE_FEED,
            ratioProviderAddress: weETH_eETH_AGGREGATOR,
            pairDescription: 'Capped weETH / eETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_075964667602784803,
              snapshotTimestamp: 1756871339, // 3-SEPT-2025
              maxYearlyRatioGrowthPercent: 8_75
            })
          })
        )
      );
  }

  function USDTAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Plasma.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDT_PRICE_FEED),
            adapterDescription: 'Capped USDT/USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function wrsETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Plasma.ACL_MANAGER,
            baseAggregatorAddress: WETH_PRICE_FEED,
            ratioProviderAddress: wrsETH_ETH_AGGREGATOR,
            pairDescription: 'Capped wrsETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_053852130305419568,
              snapshotTimestamp: 1757776775, // Sept-13-2025
              maxYearlyRatioGrowthPercent: 9_83
            })
          })
        )
      );
  }
}

contract DeploySUSDePlasma is PlasmaScript {
  function run() external broadcast {
    new CLRatePriceCapAdapter(
      abi.decode(CapAdaptersCodePlasma.sUSDeAdapterParams(), (IPriceCapAdapter.CapAdapterParams))
    );
  }
}

contract DeployWeEthPlasma is PlasmaScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodePlasma.weETHAdapterCode());
  }
}

contract DeployUSDTPlasma is PlasmaScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodePlasma.USDTAdapterCode());
  }
}

contract DeployWrsEthPlasma is PlasmaScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodePlasma.wrsETHAdapterCode());
  }
}

contract DeployPtSUSDe15JAN2026Plasma is PlasmaScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodePlasma.ptSUSDeJanuary2026AdapterCode());
  }
}

contract DeployPtUSDe15JAN2026Plasma is PlasmaScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodePlasma.ptUSDeJanuary2026AdapterCode());
  }
}

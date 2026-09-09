// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {MonadScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Monad, AaveV3MonadAssets} from 'aave-address-book/AaveV3Monad.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';

import {OneUSDFixedAdapter} from '../src/contracts/misc-adapters/OneUSDFixedAdapter.sol';
import {FixedPriceAdapter} from '../src/contracts/misc-adapters/FixedPriceAdapter.sol';
import {ScaledPriceAdapter} from '../src/contracts/misc-adapters/ScaledPriceAdapter.sol';
import {CLRatePriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {PriceCapAdapterStable, IPriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IPriceCapAdapter, IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {PendlePriceCapAdapter, IPendlePriceCapAdapter} from '../src/contracts/PendlePriceCapAdapter.sol';

library CapAdaptersCodeMonad {
  using SafeCast for uint256;

  address public constant ETH_SVR_USD_PRICE_FEED = 0xcE6538287B42D833f294662edad8B3dA070C6902;
  address public constant cbBTC_SVR_USD_PRICE_FEED = 0x1AF85c71aa71cA1138308012400cc0D784A88e8A;
  address public constant MON_SVR_USD_PRICE_FEED = 0x432AAcD32253B6683f6483fB0d3285bA0082EfDb;
  address public constant USDT0_SVR_USD_PRICE_FEED = 0xaAF8D304F82e386f7c777bd61724B8015B087d1d;
  address public constant USDC_SVR_USD_PRICE_FEED = 0x6789f81a983AfE7bd4C2a557c27084Ab705e56AB;
  address public constant AUSD_SVR_USD_PRICE_FEED = 0xEd21588eA25ADC77384d47A466F0F75EEa58eBf3;

  address public constant sUSDe_USD_MARKET_FEED = 0xB7E7A36A0Fc6543C10f4F9B60E942F1b628f2a13;

  address public constant wstETH_stETH_Exchange_Rate = 0xDBFFF41Aca92EE1d8Cb9Fff6432f345ae64bEF09;
  address public constant weETH_eETH_Exchange_Rate = 0x87DC38591B6e151A7aEc05D8efcCc8f321906C32;
  address public constant sUSDe_USDe_Exchange_Rate = 0x34047f0e5261103f384F20b76A324b86d192f698;
  address public constant syrupUSDC_USDC_Exchange_Rate = 0xaeC21ef8f7aA33687c647BFEDaA8CD7F7855973F;

  address public constant PT_AUSD_08_OCT_2026 = 0x9FC74f8Ed616B5BaF52a170caa97d6d3898602d1;

  /// @dev Wraps an 18-dec SVR feed so it reports the standard 8-dec USD price.
  function scaledAdapterCode(address svrFeed) internal pure returns (bytes memory) {
    return abi.encodePacked(type(ScaledPriceAdapter).creationCode, abi.encode(svrFeed));
  }

  function USDT0AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Monad.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(
              GovV3Helpers.predictDeterministicAddress(scaledAdapterCode(USDT0_SVR_USD_PRICE_FEED))
            ),
            adapterDescription: 'Capped USDT0 / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function USDCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Monad.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(
              GovV3Helpers.predictDeterministicAddress(scaledAdapterCode(USDC_SVR_USD_PRICE_FEED))
            ),
            adapterDescription: 'Capped USDC / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function AUSDAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Monad.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(
              GovV3Helpers.predictDeterministicAddress(scaledAdapterCode(AUSD_SVR_USD_PRICE_FEED))
            ),
            adapterDescription: 'Capped AUSD / USD',
            priceCap: int256(1.04 * 1e8)
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
            aclManager: AaveV3Monad.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(
              GovV3Helpers.predictDeterministicAddress(scaledAdapterCode(USDT0_SVR_USD_PRICE_FEED))
            ),
            adapterDescription: 'Capped USDe / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function ghoFixedAdapterCode() internal pure returns (bytes memory) {
    return abi.encodePacked(type(OneUSDFixedAdapter).creationCode);
  }

  function wstETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Monad.ACL_MANAGER,
            baseAggregatorAddress: GovV3Helpers.predictDeterministicAddress(
              scaledAdapterCode(ETH_SVR_USD_PRICE_FEED)
            ),
            ratioProviderAddress: wstETH_stETH_Exchange_Rate,
            pairDescription: 'Capped wstETH / stETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_237177964998796368,
              snapshotTimestamp: 1781683096, // block 81835000, ~2026-06-17
              maxYearlyRatioGrowthPercent: 10_70
            })
          })
        )
      );
  }

  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Monad.ACL_MANAGER,
            baseAggregatorAddress: GovV3Helpers.predictDeterministicAddress(
              scaledAdapterCode(ETH_SVR_USD_PRICE_FEED)
            ),
            ratioProviderAddress: weETH_eETH_Exchange_Rate,
            pairDescription: 'Capped weETH / eETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_097197043704895136,
              snapshotTimestamp: 1781683096, // block 81835000, ~2026-06-17
              maxYearlyRatioGrowthPercent: 9_53
            })
          })
        )
      );
  }

  function sUSDeAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Monad.ACL_MANAGER,
            baseAggregatorAddress: GovV3Helpers.predictDeterministicAddress(USDT0AdapterCode()),
            ratioProviderAddress: sUSDe_USDe_Exchange_Rate,
            pairDescription: 'Capped sUSDe / USDT0 / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_235842174724291123, // sUSDe/USDe Avalanche feed latestAnswer @ ts below
              snapshotTimestamp: 1781779295, // 2026-06-18 10:41 UTC (7d before deployment prep)
              maxYearlyRatioGrowthPercent: 11_17
            })
          })
        )
      );
  }

  function syrupUSDCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Monad.ACL_MANAGER,
            baseAggregatorAddress: GovV3Helpers.predictDeterministicAddress(USDCAdapterCode()),
            ratioProviderAddress: syrupUSDC_USDC_Exchange_Rate,
            pairDescription: 'Capped SyrupUSDC / USDC / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_169253921608684199, // syrupUSDC/USDC Avalanche feed latestAnswer @ ts below
              snapshotTimestamp: 1781779295, // 2026-06-18 10:41 UTC (7d before deployment prep)
              maxYearlyRatioGrowthPercent: 8_05
            })
          })
        )
      );
  }

  function fixedMUsdAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(FixedPriceAdapter).creationCode,
        abi.encode(address(AaveV3Monad.ACL_MANAGER), 8, int256(1 * 1e8), 'Fixed mUSD/USD')
      );
  }

  function ptAUSDOctober2026AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3MonadAssets.AUSD_ORACLE,
            pendlePrincipalToken: PT_AUSD_08_OCT_2026,
            maxDiscountRatePerYear: uint256(8.829e16).toUint64(),
            discountRatePerYear: uint256(6.661e16).toUint64(),
            aclManager: address(AaveV3Monad.ACL_MANAGER),
            description: 'PT Capped AUSD AUSD/USD linear discount 8OCT2026'
          })
        )
      );
  }
}

contract DeployScaledETHSvrMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMonad.scaledAdapterCode(CapAdaptersCodeMonad.ETH_SVR_USD_PRICE_FEED)
    );
  }
}

contract DeployScaledCbBTCSvrMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMonad.scaledAdapterCode(CapAdaptersCodeMonad.cbBTC_SVR_USD_PRICE_FEED)
    );
  }
}

contract DeployScaledMONSvrMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMonad.scaledAdapterCode(CapAdaptersCodeMonad.MON_SVR_USD_PRICE_FEED)
    );
  }
}

contract DeployScaledUSDT0SvrMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMonad.scaledAdapterCode(CapAdaptersCodeMonad.USDT0_SVR_USD_PRICE_FEED)
    );
  }
}

contract DeployScaledUSDCSvrMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMonad.scaledAdapterCode(CapAdaptersCodeMonad.USDC_SVR_USD_PRICE_FEED)
    );
  }
}

contract DeployScaledAUSDSvrMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMonad.scaledAdapterCode(CapAdaptersCodeMonad.AUSD_SVR_USD_PRICE_FEED)
    );
  }
}

contract DeployUSDT0Monad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.USDT0AdapterCode());
  }
}

contract DeployUSDCMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.USDCAdapterCode());
  }
}

contract DeployAUSDMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.AUSDAdapterCode());
  }
}

contract DeployUSDeMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.USDeAdapterCode());
  }
}

contract DeployGhoMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.ghoFixedAdapterCode());
  }
}

contract DeployWstETHMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.wstETHAdapterCode());
  }
}

contract DeployWeETHMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.weETHAdapterCode());
  }
}

contract DeploySUSDeMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.sUSDeAdapterCode());
  }
}

contract DeploySyrupUSDCMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.syrupUSDCAdapterCode());
  }
}

contract DeployFixedMUSDMonad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.fixedMUsdAdapterCode());
  }
}

contract DeployPtAUSD08OCT2026Monad is MonadScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMonad.ptAUSDOctober2026AdapterCode());
  }
}

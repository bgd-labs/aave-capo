// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {EthereumScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV3EthereumLido, AaveV3EthereumLidoAssets} from 'aave-address-book/AaveV3EthereumLido.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {ChainlinkEthereum} from 'aave-address-book/ChainlinkEthereum.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IPriceCapAdapter, IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../src/interfaces/IPriceCapAdapterStable.sol';
import {WeETHPriceCapAdapter} from '../src/contracts/lst-adapters/WeETHPriceCapAdapter.sol';
import {OsETHPriceCapAdapter} from '../src/contracts/lst-adapters/OsETHPriceCapAdapter.sol';
import {EthXPriceCapAdapter} from '../src/contracts/lst-adapters/EthXPriceCapAdapter.sol';
import {SUSDePriceCapAdapter} from '../src/contracts/lst-adapters/SUSDePriceCapAdapter.sol';
import {sUSDSPriceCapAdapter} from '../src/contracts/lst-adapters/sUSDSPriceCapAdapter.sol';
import {EzETHPriceCapAdapter} from '../src/contracts/lst-adapters/EzETHPriceCapAdapter.sol';
import {sDAIMainnetPriceCapAdapter} from '../src/contracts/lst-adapters/sDAIMainnetPriceCapAdapter.sol';
import {RsETHPriceCapAdapter} from '../src/contracts/lst-adapters/RsETHPriceCapAdapter.sol';
import {EBTCPriceCapAdapter} from '../src/contracts/lst-adapters/EBTCPriceCapAdapter.sol';
import {PendlePriceCapAdapter, IPendlePriceCapAdapter} from '../src/contracts/PendlePriceCapAdapter.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';
import {EUSDePriceCapAdapter} from '../src/contracts/lst-adapters/EUSDePriceCapAdapter.sol';
import {WstETHPriceCapAdapter} from '../src/contracts/lst-adapters/WstETHPriceCapAdapter.sol';
import {RETHPriceCapAdapter} from '../src/contracts/lst-adapters/RETHPriceCapAdapter.sol';
import {CbETHPriceCapAdapter} from '../src/contracts/lst-adapters/CbETHPriceCapAdapter.sol';
import {TETHPriceCapAdapter} from '../src/contracts/lst-adapters/TETHPriceCapAdapter.sol';
import {CLSynchronicityPriceAdapterPegToBase} from 'cl-synchronicity-price-adapter/contracts/CLSynchronicityPriceAdapterPegToBase.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregatorsMainnet.sol';
import {EURPriceCapAdapterStable, IEURPriceCapAdapterStable} from '../src/contracts/misc-adapters/EURPriceCapAdapterStable.sol';

library CapAdaptersCodeEthereum {
  using SafeCast for uint256;

  address public constant weETH = 0xCd5fE23C85820F7B72D0926FC9b05b43E359b7ee;
  address public constant osETH_VAULT_CONTROLLER = 0x2A261e60FB14586B474C208b1B7AC6D0f5000306;
  address public constant USDe_PRICE_FEED = 0xa569d910839Ae8865Da8F8e70FfFb0cBA869F961;
  address public constant STADER_STAKE_POOLS_MANAGER = 0xcf5EA1b38380f6aF39068375516Daf40Ed70D299;
  address public constant sUSDe = 0x9D39A5DE30e57443BfF2A8307A4256c8797A3497;
  address public constant DAI_PRICE_FEED = 0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9;
  address public constant sUSDS = 0xa3931d71877C0E7a3148CB7Eb4463524FEc27fbD;
  address public constant ezETH_RESTAKE_MANAGER = 0x74a09653A083691711cF8215a6ab074BB4e99ef5;
  address public constant rsETH_LRT_ORACLE = 0x349A73444b1a310BAe67ef67973022020d70020d;
  address public constant eBTC_ACCOUNTANT = 0x1b293DC39F94157fA0D1D36d7e0090C8B8B8c13F;
  address public constant RLUSD_PRICE_FEED = 0x26C46B7aD0012cA71F2298ada567dC9Af14E7f2A;
  address public constant USDtb_PRICE_FEED = 0x66704DAD467A7cA508B3be15865D9B9F3E186c90;
  address public constant USDT_PRICE_FEED = 0x3E7d1eAB13ad0104d2750B8863b489D65364e32D;
  address public constant eUSDe = 0x90D2af7d622ca3141efA4d8f1F24d86E5974Cc8F;
  address public constant PT_sUSDe_31_JULY_2025 = 0x3b3fB9C57858EF816833dC91565EFcd85D96f634;
  address public constant PT_eUSDe_29_MAY_2025 = 0x50D2C7992b802Eef16c04FeADAB310f31866a545;
  address public constant PT_eUSDe_14_AUG_2025 = 0x14Bdc3A3AE09f5518b923b69489CBcAfB238e617;
  address public constant PT_USDe_31_JUL_2025 = 0x917459337CaAC939D41d7493B3999f571D20D667;
  address public constant stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
  address public constant rETH = 0xae78736Cd615f374D3085123A210448E74Fc6393;
  address public constant tETH = 0xD11c452fc99cF405034ee446803b6F6c1F6d5ED8;
  address public constant EURC_PRICE_FEED = 0x04F84020Fdf10d9ee64D1dcC2986EDF2F556DA11;
  address public constant EUR_PRICE_FEED = 0xb49f677943BC038e9857d61E7d053CaA2C1734C1;

  function ptSUSDeJuly2025AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3EthereumAssets.USDT_ORACLE,
            pendlePrincipalToken: PT_sUSDe_31_JULY_2025,
            maxDiscountRatePerYear: uint256(21.22e16).toUint64(),
            discountRatePerYear: uint256(7.5124e16).toUint64(),
            aclManager: address(AaveV3Ethereum.ACL_MANAGER),
            description: 'PT Capped sUSDe USDT/USD linear discount 31JUL2025'
          })
        )
      );
  }

  function ptEUSDeMay2025AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3EthereumAssets.USDT_ORACLE,
            pendlePrincipalToken: PT_eUSDe_29_MAY_2025,
            maxDiscountRatePerYear: uint256(39.22e16).toUint64(),
            discountRatePerYear: uint256(7.87e16).toUint64(),
            aclManager: address(AaveV3Ethereum.ACL_MANAGER),
            description: 'PT Capped eUSDe USDT/USD linear discount 29MAY2025'
          })
        )
      );
  }

  function ptEUSDeAugust2025AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3EthereumAssets.USDT_ORACLE,
            pendlePrincipalToken: PT_eUSDe_14_AUG_2025,
            maxDiscountRatePerYear: uint256(29.781e16).toUint64(),
            discountRatePerYear: uint256(9.037e16).toUint64(),
            aclManager: address(AaveV3Ethereum.ACL_MANAGER),
            description: 'PT Capped eUSDe USDT/USD linear discount 14AUG2025'
          })
        )
      );
  }

  function ptUSDeJuly2025AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3EthereumAssets.USDT_ORACLE,
            pendlePrincipalToken: PT_USDe_31_JUL_2025,
            maxDiscountRatePerYear: uint256(29.21e16).toUint64(),
            discountRatePerYear: uint256(8.47e16).toUint64(),
            aclManager: address(AaveV3Ethereum.ACL_MANAGER),
            description: 'PT Capped USDe USDT/USD linear discount 31JUL2025'
          })
        )
      );
  }

  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(WeETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
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
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
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

  function ethXAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(EthXPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
            ratioProviderAddress: STADER_STAKE_POOLS_MANAGER,
            pairDescription: 'Capped ethX / ETH / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1029650229444067238,
              snapshotTimestamp: 1715877911,
              maxYearlyRatioGrowthPercent: 9_24
            })
          })
        )
      );
  }

  function sUSDeAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(SUSDePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: AaveV3EthereumAssets.USDe_ORACLE,
            ratioProviderAddress: sUSDe,
            pairDescription: 'Capped sUSDe / USDe / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1073500440864333503,
              snapshotTimestamp: 1717576067,
              maxYearlyRatioGrowthPercent: 50_00
            })
          })
        )
      );
  }

  function sDAIAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(sDAIMainnetPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: DAI_PRICE_FEED,
            ratioProviderAddress: MiscEthereum.sDAI_POT,
            pairDescription: 'Capped sDAI / DAI / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_155737072956268043878995612,
              snapshotTimestamp: 1745242379,
              maxYearlyRatioGrowthPercent: 9_69
            })
          })
        )
      );
  }

  function USDSAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(DAI_PRICE_FEED),
            adapterDescription: 'Capped USDS <-> DAI / USD',
            priceCap: int256(1.04 * 1e18)
          })
        )
      );
  }

  function sUSDSAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(sUSDSPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: GovV3Helpers.predictDeterministicAddress(USDSAdapterCode()),
            ratioProviderAddress: sUSDS,
            pairDescription: 'Capped sUSDS / USDS <-> DAI / USD',
            minimumSnapshotDelay: 4 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1000000000000000000,
              snapshotTimestamp: 1725455495,
              maxYearlyRatioGrowthPercent: 15_00
            })
          })
        )
      );
  }

  function ezETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(EzETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3EthereumLido.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
            ratioProviderAddress: ezETH_RESTAKE_MANAGER,
            pairDescription: 'Capped ezETH / ezETH(ETH) / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1019883708003361006,
              snapshotTimestamp: 1727172839, // Sep-24-2024
              maxYearlyRatioGrowthPercent: 10_89
            })
          })
        )
      );
  }

  function rsETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(RsETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
            ratioProviderAddress: rsETH_LRT_ORACLE,
            pairDescription: 'Capped rsETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1026549069391100903,
              snapshotTimestamp: 1728904283, // Oct-14-2024
              maxYearlyRatioGrowthPercent: 9_83
            })
          })
        )
      );
  }

  function eBTCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(EBTCPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_BTC_USD,
            ratioProviderAddress: eBTC_ACCOUNTANT,
            pairDescription: 'Capped eBTC / BTC / USD',
            minimumSnapshotDelay: 1 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 100000000,
              snapshotTimestamp: 1742388719, // Mar-19-2025
              maxYearlyRatioGrowthPercent: 0
            })
          })
        )
      );
  }

  function RLUSDAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(RLUSD_PRICE_FEED),
            adapterDescription: 'Capped RLUSD / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function USDtbAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDtb_PRICE_FEED),
            adapterDescription: 'Capped USDtb / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function eUSDeAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(EUSDePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: USDT_PRICE_FEED,
            ratioProviderAddress: eUSDe,
            pairDescription: 'Capped eUSDe / USDe / USD',
            minimumSnapshotDelay: 1 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_000000000000000000,
              snapshotTimestamp: 1745242379, // Apr-21-2025
              maxYearlyRatioGrowthPercent: 0
            })
          })
        )
      );
  }

  function wstETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(WstETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
            ratioProviderAddress: stETH,
            pairDescription: 'Capped wstETH / stETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_157209899495068171,
              snapshotTimestamp: 1708004591, // Feb-15-2024
              maxYearlyRatioGrowthPercent: 9_68
            })
          })
        )
      );
  }

  function rETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(RETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
            ratioProviderAddress: rETH,
            pairDescription: 'Capped rETH / ETH / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_098284517740008249,
              snapshotTimestamp: 1708004591, // Feb-15-2024
              maxYearlyRatioGrowthPercent: 9_30
            })
          })
        )
      );
  }

  function cbETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CbETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
            ratioProviderAddress: AaveV3EthereumAssets.cbETH_UNDERLYING,
            pairDescription: 'Capped cbETH / ETH / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_063814269953974334,
              snapshotTimestamp: 1708004591, // Feb-15-2024
              maxYearlyRatioGrowthPercent: 8_12
            })
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
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(ChainlinkEthereum.SVR_USDC_USD),
            adapterDescription: 'Capped USDC / USD',
            priceCap: int256(1.04 * 1e8)
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
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(ChainlinkEthereum.SVR_USDT_USD),
            adapterDescription: 'Capped USDT / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function WBTCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterPegToBase).creationCode,
        abi.encode(
          ChainlinkEthereum.SVR_BTC_USD,
          BaseAggregatorsMainnet.WBTC_BTC_AGGREGATOR,
          8,
          'wBTC/BTC/USD'
        )
      );
  }

  function EURCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(EURPriceCapAdapterStable).creationCode,
        abi.encode(
          IEURPriceCapAdapterStable.CapAdapterStableParamsEUR({
            aclManager: AaveV3Ethereum.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(EURC_PRICE_FEED),
            baseToUsdAggregator: IChainlinkAggregator(EUR_PRICE_FEED),
            adapterDescription: 'Capped EURC/USD',
            priceCapRatio: int256(1.04 * 1e8),
            ratioDecimals: 8
          })
        )
      );
  }

  function tETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(TETHPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3EthereumLido.ACL_MANAGER,
            baseAggregatorAddress: ChainlinkEthereum.SVR_ETH_USD,
            ratioProviderAddress: tETH,
            pairDescription: 'Capped tETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_002302911335141630,
              snapshotTimestamp: 1748925539, // Jun-03-2025
              maxYearlyRatioGrowthPercent: 12_04
            })
          })
        )
      );
  }
}

contract DeployTETHEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.tETHAdapterCode());
  }
}

contract DeployEURCEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.EURCAdapterCode());
  }
}

contract DeployWsETHEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.wstETHAdapterCode());
  }
}

contract DeployRETHEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.rETHAdapterCode());
  }
}

contract DeployCbETHEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.cbETHAdapterCode());
  }
}

contract DeployWBTCEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.WBTCAdapterCode());
  }
}

contract DeployUSDCEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USDCAdapterCode());
  }
}

contract DeployUSDTEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USDTAdapterCode());
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

contract DeployUSDeEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USDeAdapterCode());
  }
}

contract DeployEthXEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.ethXAdapterCode());
  }
}

contract DeploySUSDeEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.sUSDeAdapterCode());
  }
}

contract DeployUSDSEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USDSAdapterCode());
  }
}

contract DeploysUSDSEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.sUSDSAdapterCode());
  }
}

contract DeployEzEthEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.ezETHAdapterCode());
  }
}

contract DeploySDaiEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.sDAIAdapterCode());
  }
}

contract DeployRsEthEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.rsETHAdapterCode());
  }
}

contract DeployEBTCEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.eBTCAdapterCode());
  }
}

contract DeployRLUSDEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.RLUSDAdapterCode());
  }
}

contract DeployUSDtbEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USDtbAdapterCode());
  }
}

contract DeployPtSUSDe31JUL2025Ethereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.ptSUSDeJuly2025AdapterCode());
  }
}

contract DeployPtEUSDe29MAY2025Ethereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.ptEUSDeMay2025AdapterCode());
  }
}

contract DeployPtEUSDe14AUG2025Ethereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.ptEUSDeAugust2025AdapterCode());
  }
}

contract DeployPtUSDe31JUL2025Ethereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.ptUSDeJuly2025AdapterCode());
  }
}

contract DeployEUSDeEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.eUSDeAdapterCode());
  }
}

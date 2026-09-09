// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {XLayerScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3XLayer, AaveV3XLayerAssets} from 'aave-address-book/AaveV3XLayer.sol';
import {MiscXLayer} from 'aave-address-book/MiscXLayer.sol';
import {SafeCast} from 'openzeppelin-contracts/contracts/utils/math/SafeCast.sol';

import {XStakedPriceCapAdapter, IPriceCapAdapter} from '../src/contracts/lst-adapters/XStakedPriceCapAdapter.sol';
import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {OneUSDFixedAdapter} from '../src/contracts/misc-adapters/OneUSDFixedAdapter.sol';
import {IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../src/interfaces/IPriceCapAdapterStable.sol';
import {PendlePriceCapAdapter, IPendlePriceCapAdapter} from '../src/contracts/PendlePriceCapAdapter.sol';

library CapAdaptersCodeXLayer {
  using SafeCast for uint256;

  address public constant CL_USDC_USD_FEED = 0xB8a08c178D96C315FbFB5661ABD208477391BC40;
  address public constant CL_USDT_USD_FEED = 0xb928a0678352005a2e51F614efD0b54C9830dB80;
  address public constant CL_USDG_USD_FEED = 0x385C6bDDE06b0E438319bF4ddBfFe51C521ABf3D;
  address public constant CL_SOL_USD_FEED = 0xF959E1B5cA535C28aD24F7f672Bf1A93900810cF;
  address public constant CL_ETH_USD_FEED = 0x8b85b50535551F8E8cDAF78dA235b5Cf1005907b;

  address public constant xBETH = 0xAFeab3B85B6A56cF5F02317F0f7A23340eb983D7;
  address public constant xOKSOL = 0x14a686103854DAB7b8801E31979CAA595835B25d;

  address public constant PT_USDG_29_OCT_2026 = 0x9a09a9E491DB3dd8Ada5B1B889991AC9Ad5fd362;

  function xOKSOLAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(XStakedPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3XLayer.ACL_MANAGER,
            baseAggregatorAddress: CL_SOL_USD_FEED,
            ratioProviderAddress: xOKSOL,
            pairDescription: 'Capped xOKSOL / SOL / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_005578579856753908,
              snapshotTimestamp: 1772539036, // Mar 03 2026 (Block: 53770000)
              maxYearlyRatioGrowthPercent: 13_68
            })
          })
        )
      );
  }

  function xBETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(XStakedPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3XLayer.ACL_MANAGER,
            baseAggregatorAddress: CL_ETH_USD_FEED,
            ratioProviderAddress: xBETH,
            pairDescription: 'Capped xBETH / ETH / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_002354270813048698,
              snapshotTimestamp: 1772539036, // Mar 03 2026 (Block: 53770000)
              maxYearlyRatioGrowthPercent: 9_68
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
            aclManager: AaveV3XLayer.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(CL_USDC_USD_FEED),
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
            aclManager: AaveV3XLayer.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(CL_USDT_USD_FEED),
            adapterDescription: 'Capped USDT / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function USDGAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3XLayer.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(CL_USDG_USD_FEED),
            adapterDescription: 'Capped USDG / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function oneUSDFixedAdapterCode() internal pure returns (bytes memory) {
    return abi.encodePacked(type(OneUSDFixedAdapter).creationCode);
  }

  function ptUSDGOctober2026AdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PendlePriceCapAdapter).creationCode,
        abi.encode(
          IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
            assetToUsdAggregator: AaveV3XLayerAssets.USDG_ORACLE,
            pendlePrincipalToken: PT_USDG_29_OCT_2026,
            maxDiscountRatePerYear: uint256(11.08e16).toUint64(),
            discountRatePerYear: uint256(3.106e16).toUint64(),
            aclManager: address(AaveV3XLayer.ACL_MANAGER),
            description: 'PT Capped USDG USDG/USD linear discount 29OCT2026'
          })
        )
      );
  }
}

contract DeployUSDCXLayer is XLayerScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeXLayer.USDCAdapterCode());
  }
}

contract DeployUSDTXLayer is XLayerScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeXLayer.USDTAdapterCode());
  }
}

contract DeployUSDGXLayer is XLayerScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeXLayer.USDGAdapterCode());
  }
}

contract DeployOneUsdXLayer is XLayerScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeXLayer.oneUSDFixedAdapterCode());
  }
}

contract DeployXOKSOLXLayer is XLayerScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeXLayer.xOKSOLAdapterCode());
  }
}

contract DeployXBETHXLayer is XLayerScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeXLayer.xBETHAdapterCode());
  }
}

contract DeployPtUSDG08OCT2026XLayer is XLayerScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeXLayer.ptUSDGOctober2026AdapterCode());
  }
}

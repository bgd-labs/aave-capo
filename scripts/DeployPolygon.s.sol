// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {PolygonScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {BaseAggregatorsPolygon} from 'cl-synchronicity-price-adapter/lib/BaseAggregatorsPolygon.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {MaticPriceCapAdapter} from '../src/contracts/MaticPriceCapAdapter.sol';
import {AaveV3PolygonPayload} from '../src/contracts/payloads/AaveV3PolygonPayload.sol';

library CapAdaptersCodePolygon {
  bytes public constant USDT_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Polygon.ACL_MANAGER,
        AaveV3PolygonAssets.USDT_ORACLE,
        'Capped USDT/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  //USDC.e
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Polygon.ACL_MANAGER,
        AaveV3PolygonAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant DAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Polygon.ACL_MANAGER,
        AaveV3PolygonAssets.DAI_ORACLE,
        'Capped DAI/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );

  // TODO: CL feed used
  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Polygon.ACL_MANAGER,
        AaveV3PolygonAssets.WETH_ORACLE,
        BaseAggregatorsPolygon.WSTETH_STETH_AGGREGATOR,
        'Capped wstETH / stETH(ETH) / USD', // TODO: is it actually going to STETH, but then using ETH feed
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
  bytes public constant stMATIC_ADAPTER_CODE =
    abi.encodePacked(
      type(MaticPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Polygon.ACL_MANAGER,
        AaveV3PolygonAssets.WMATIC_ORACLE,
        BaseAggregatorsPolygon.STMATIC_RATE_PROVIDER,
        'Capped stMATIC / MATIC / USD',
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
  bytes public constant MaticX_ADAPTER_CODE =
    abi.encodePacked(
      type(MaticPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Polygon.ACL_MANAGER,
        AaveV3PolygonAssets.WMATIC_ORACLE,
        BaseAggregatorsPolygon.MATICX_RATE_PROVIDER,
        'Capped MaticX / MATIC / USD',
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
}

contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    AaveV3PolygonPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodePolygon.USDT_ADAPTER_CODE
    );
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodePolygon.USDC_ADAPTER_CODE
    );
    adapters.daiAdapter = GovV3Helpers.deployDeterministic(CapAdaptersCodePolygon.DAI_ADAPTER_CODE);
    adapters.wstEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodePolygon.wstETH_ADAPTER_CODE
    );
    adapters.stMaticAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodePolygon.stMATIC_ADAPTER_CODE
    );
    adapters.maticXAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodePolygon.MaticX_ADAPTER_CODE
    );

    GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3PolygonPayload).creationCode, abi.encode(adapters))
    );
  }
}

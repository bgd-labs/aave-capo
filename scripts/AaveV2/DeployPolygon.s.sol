// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {PolygonScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {CLSynchronicityPriceAdapterBaseToPeg} from 'cl-synchronicity-price-adapter/contracts/CLSynchronicityPriceAdapterBaseToPeg.sol';

import {PriceCapAdapterStable} from '../../src/contracts/PriceCapAdapterStable.sol';
import {AaveV2PolygonPayload} from '../../src/contracts/payloads/AaveV2/AaveV2PolygonPayload.sol';

library CapAdaptersCodePolygon {
  function USDTCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Polygon.ACL_MANAGER,
          AaveV3PolygonAssets.USDT_ORACLE,
          'Capped USDT / USD',
          int256(1.04 * 1e8)
        )
      );
  }

  function USDCCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Polygon.ACL_MANAGER,
          AaveV3PolygonAssets.USDC_ORACLE,
          'Capped USDC / USD',
          int256(1.04 * 1e8)
        )
      );
  }

  function DAICappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Polygon.ACL_MANAGER,
          AaveV3PolygonAssets.DAI_ORACLE,
          'Capped DAI / USD',
          int256(1.04 * 1e8)
        )
      );
  }
}

library AdaptersEthBasedPolygon {
  function USDTtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3PolygonAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodePolygon.USDTCappedAdapterCode()),
          18,
          'Capped USDT / USD / ETH'
        )
      );
  }

  function USDCtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3PolygonAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodePolygon.USDCCappedAdapterCode()),
          18,
          'Capped USDC / USD / ETH'
        )
      );
  }

  function DAItoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3PolygonAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodePolygon.DAICappedAdapterCode()),
          18,
          'Capped DAI / USD / ETH'
        )
      );
  }
}

contract DeployPolygonAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV2PolygonPayload.Adapters memory adapters;

    GovV3Helpers.deployDeterministic(CapAdaptersCodePolygon.USDTCappedAdapterCode());
    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedPolygon.USDTtoETHAdapterCode()
    );

    GovV3Helpers.deployDeterministic(CapAdaptersCodePolygon.USDCCappedAdapterCode());
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedPolygon.USDCtoETHAdapterCode()
    );

    GovV3Helpers.deployDeterministic(CapAdaptersCodePolygon.DAICappedAdapterCode());
    adapters.daiAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedPolygon.DAItoETHAdapterCode()
    );

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV2PolygonPayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployPolygon is PolygonScript, DeployPolygonAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}

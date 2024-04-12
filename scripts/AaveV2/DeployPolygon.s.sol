// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {PolygonScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {CLSynchronicityPriceAdapterBaseToPeg} from 'cl-synchronicity-price-adapter/contracts/CLSynchronicityPriceAdapterBaseToPeg.sol';

import {PriceCapAdapterStable} from '../../src/contracts/PriceCapAdapterStable.sol';
import {AaveV2PolygonPayload} from '../../src/contracts/payloads/AaveV2/AaveV2PolygonPayload.sol';

library AdaptersEthBasedPolygon {
  // https://polygonscan.com/address/0xaA574f4f6E124E77a7a1B5Ed91c8b407000A7730
  address public constant USDT_ORACLE = 0xaA574f4f6E124E77a7a1B5Ed91c8b407000A7730;

  // https://polygonscan.com/address/0x17E33D122FC34c7ad8FBd4a1995Dff9c8aE675eb
  address public constant USDC_ORACLE = 0x17E33D122FC34c7ad8FBd4a1995Dff9c8aE675eb;

  // https://polygonscan.com/address/0xF86577E7d27Ed35b85A7645c58bAaA64453fe32B
  address public constant DAI_ORACLE = 0xF86577E7d27Ed35b85A7645c58bAaA64453fe32B;

  function USDTtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3PolygonAssets.WETH_ORACLE, USDT_ORACLE, 18, 'Capped USDT / USD / ETH')
      );
  }

  function USDCtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3PolygonAssets.WETH_ORACLE, USDC_ORACLE, 18, 'Capped USDC / USD / ETH')
      );
  }

  function DAItoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3PolygonAssets.WETH_ORACLE, DAI_ORACLE, 18, 'Capped DAI / USD / ETH')
      );
  }
}

contract DeployPolygonAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV2PolygonPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedPolygon.USDTtoETHAdapterCode()
    );

    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedPolygon.USDCtoETHAdapterCode()
    );

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

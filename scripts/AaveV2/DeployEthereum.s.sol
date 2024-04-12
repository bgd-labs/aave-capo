// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {CLSynchronicityPriceAdapterBaseToPeg} from 'cl-synchronicity-price-adapter/contracts/CLSynchronicityPriceAdapterBaseToPeg.sol';
import {CLSynchronicityPriceAdapterPegToBase} from 'cl-synchronicity-price-adapter/contracts/CLSynchronicityPriceAdapterPegToBase.sol';

import {PriceCapAdapterStable} from '../../src/contracts/PriceCapAdapterStable.sol';
import {AaveV2EthereumPayload} from '../../src/contracts/payloads/AaveV2/AaveV2EthereumPayload.sol';

library CapAdaptersCodeEthereum {
  // https://etherscan.io/address/0x09023c0DA49Aaf8fc3fA3ADF34C6A7016D38D5e3
  address public constant USDP_ORACLE = 0x09023c0DA49Aaf8fc3fA3ADF34C6A7016D38D5e3;

  // https://etherscan.io/address/0xec746eCF986E2927Abd291a2A1716c940100f8Ba
  address public constant TUSD_ORACLE = 0xec746eCF986E2927Abd291a2A1716c940100f8Ba;

  // https://etherscan.io/address/0xfAA9147190c2C2cc5B8387B4f49016bDB3380572
  address public constant FDUSD_ORACLE = 0xfAA9147190c2C2cc5B8387B4f49016bDB3380572;

  function USDPCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(AaveV3Ethereum.ACL_MANAGER, USDP_ORACLE, 'Capped USDP / USD', int256(1.04 * 1e8))
      );
  }

  function TUSDCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(AaveV3Ethereum.ACL_MANAGER, TUSD_ORACLE, 'Capped TUSD / USD', int256(1.04 * 1e8))
      );
  }

  function BUSDCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Ethereum.ACL_MANAGER,
          FDUSD_ORACLE,
          'Capped BUSD (fdUSD) / USD',
          int256(1.04 * 1e8)
        )
      );
  }

  function sUSDtoUSDAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterPegToBase).creationCode,
        abi.encode(
          AaveV3EthereumAssets.WETH_ORACLE, // ETH / USD
          AaveV2EthereumAssets.sUSD_ORACLE, // sUSD / ETH
          8,
          'sUSD / ETH / USD'
        )
      );
  }

  function sUSDCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Ethereum.ACL_MANAGER,
          GovV3Helpers.predictDeterministicAddress(sUSDtoUSDAdapterCode()),
          'Capped sUSD / USD',
          int256(1.04 * 1e8)
        )
      );
  }

  function USTtoUSDAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterPegToBase).creationCode,
        abi.encode(
          AaveV3EthereumAssets.WETH_ORACLE, // ETH / USD
          AaveV2EthereumAssets.UST_ORACLE, // UST / ETH
          8,
          'UST / ETH / USD'
        )
      );
  }

  function USTCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Ethereum.ACL_MANAGER,
          GovV3Helpers.predictDeterministicAddress(USTtoUSDAdapterCode()),
          'Capped UST / USD',
          int256(1.04 * 1e8)
        )
      );
  }
}

library AdaptersEthBasedEthereum {
  // https://etherscan.io/address/0xC26D4a1c46d884cfF6dE9800B6aE7A8Cf48B4Ff8
  address public constant USDT_ORACLE = 0xC26D4a1c46d884cfF6dE9800B6aE7A8Cf48B4Ff8;

  // https://etherscan.io/address/0x736bF902680e68989886e9807CD7Db4B3E015d3C
  address public constant USDC_ORACLE = 0x736bF902680e68989886e9807CD7Db4B3E015d3C;

  //https://etherscan.io/address/0xaEb897E1Dc6BbdceD3B9D551C71a8cf172F27AC4
  address public constant DAI_ORACLE = 0xaEb897E1Dc6BbdceD3B9D551C71a8cf172F27AC4;

  // https://etherscan.io/address/0x45D270263BBee500CF8adcf2AbC0aC227097b036
  address public constant FRAX_ORACLE = 0x45D270263BBee500CF8adcf2AbC0aC227097b036;

  // https://etherscan.io/address/0x9eCdfaCca946614cc32aF63F3DBe50959244F3af
  address public constant LUSD_ORACLE = 0x9eCdfaCca946614cc32aF63F3DBe50959244F3af;

  // https://etherscan.io/address/0xD2A593BF7594aCE1faD597adb697b5645d5edDB2
  address public constant DPI_ORACLE = 0xD2A593BF7594aCE1faD597adb697b5645d5edDB2;

  // address public constant AMPL_ORACLE = 0xe20CA8D7546932360e37E9D72c1a47334af57706;

  function USDTtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3EthereumAssets.WETH_ORACLE, USDT_ORACLE, 18, 'Capped USDT / USD / ETH')
      );
  }

  function USDCtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3EthereumAssets.WETH_ORACLE, USDC_ORACLE, 18, 'Capped USDC / USD / ETH')
      );
  }

  function DAItoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3EthereumAssets.WETH_ORACLE, DAI_ORACLE, 18, 'Capped DAI / USD / ETH')
      );
  }

  function USDPtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3EthereumAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodeEthereum.USDPCappedAdapterCode()),
          18,
          'Capped USDP / USD / ETH'
        )
      );
  }

  function FRAXtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3EthereumAssets.WETH_ORACLE, FRAX_ORACLE, 18, 'Capped FRAX / USD / ETH')
      );
  }

  function TUSDtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3EthereumAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodeEthereum.TUSDCappedAdapterCode()),
          18,
          'Capped TUSD / USD / ETH'
        )
      );
  }

  function LUSDtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3EthereumAssets.WETH_ORACLE, LUSD_ORACLE, 18, 'Capped LUSD / USD / ETH')
      );
  }

  function BUSDtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3EthereumAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodeEthereum.BUSDCappedAdapterCode()),
          18,
          'Capped BUSD (fdUSD) / USD / ETH'
        )
      );
  }

  function sUSDtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3EthereumAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodeEthereum.sUSDCappedAdapterCode()),
          18,
          'Capped sUSD / USD / ETH'
        )
      );
  }

  function USTtoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(
          AaveV3EthereumAssets.WETH_ORACLE,
          GovV3Helpers.predictDeterministicAddress(CapAdaptersCodeEthereum.USTCappedAdapterCode()),
          18,
          'Capped UST / USD / ETH'
        )
      );
  }

  // function AMPLtoETHAdapterCode() internal pure returns (bytes memory) {
  //   return
  //     abi.encodePacked(
  //       type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
  //       abi.encode(AaveV3EthereumAssets.WETH_ORACLE, AMPL_ORACLE, 18, 'AMPL / USD / ETH')
  //     );
  // }

  function DPItoETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLSynchronicityPriceAdapterBaseToPeg).creationCode,
        abi.encode(AaveV3EthereumAssets.WETH_ORACLE, DPI_ORACLE, 18, 'DPI / USD / ETH')
      );
  }
}

contract DeployEthereumAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV2EthereumPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.USDTtoETHAdapterCode()
    );

    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.USDCtoETHAdapterCode()
    );

    adapters.daiAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.DAItoETHAdapterCode()
    );

    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USDPCappedAdapterCode());
    adapters.usdpAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.USDPtoETHAdapterCode()
    );

    adapters.fraxAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.FRAXtoETHAdapterCode()
    );

    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.TUSDCappedAdapterCode());
    adapters.tusdAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.TUSDtoETHAdapterCode()
    );

    adapters.lusdAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.LUSDtoETHAdapterCode()
    );

    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.BUSDCappedAdapterCode());
    adapters.busdAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.BUSDtoETHAdapterCode()
    );

    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.sUSDtoUSDAdapterCode());
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.sUSDCappedAdapterCode());
    adapters.susdAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.sUSDtoETHAdapterCode()
    );

    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USTtoUSDAdapterCode());
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.USTCappedAdapterCode());
    adapters.ustAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.USTtoETHAdapterCode()
    );

    adapters.dpiAdapter = GovV3Helpers.deployDeterministic(
      AdaptersEthBasedEthereum.DPItoETHAdapterCode()
    );

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV2EthereumPayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployEthereum is EthereumScript, DeployEthereumAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseTestV2} from './BaseTestV2.sol';
import {IPriceCapAdapterStable, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapterStable.sol';

import {CapAdaptersCodeEthereum, AdaptersEthBasedEthereum} from '../../scripts/AaveV2/DeployEthereum.s.sol';
import {CLSynchronicityPriceAdapterBaseToPeg} from 'cl-synchronicity-price-adapter/contracts/CLSynchronicityPriceAdapterBaseToPeg.sol';

abstract contract BaseEthTestV2 is BaseTestV2 {
  constructor(
    address referenceFeed,
    ForkParams memory _forkParams,
    AdapterParams memory _adapterParams
  )
    BaseTestV2(
      referenceFeed,
      _forkParams,
      _adapterParams,
      RetrospectionParams({startBlock: 19345000, finishBlock: 19620358, step: 100000})
    )
  {}
}

contract EthereumV2USDTTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.USDT_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.USDTtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2USDCTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.USDC_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.USDCtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2DAITest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.DAI_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.DAItoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2USDPTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters = [CapAdaptersCodeEthereum.USDPCappedAdapterCode()];

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.USDP_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.USDPtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2FRAXTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.FRAX_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.FRAXtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2TUSDTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters = [CapAdaptersCodeEthereum.TUSDCappedAdapterCode()];

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.TUSD_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.TUSDtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2LUSDTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.LUSD_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.LUSDtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2BUSDTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters = [CapAdaptersCodeEthereum.BUSDCappedAdapterCode()];

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.BUSD_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.BUSDtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2sUSDTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters = [
    CapAdaptersCodeEthereum.sUSDtoUSDAdapterCode(),
    CapAdaptersCodeEthereum.sUSDCappedAdapterCode()
  ];

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.sUSD_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.sUSDtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2USTTest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters = [
    CapAdaptersCodeEthereum.USTtoUSDAdapterCode(),
    CapAdaptersCodeEthereum.USTCappedAdapterCode()
  ];

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.UST_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.USTtoETHAdapterCode()
      })
    )
  {}
}

contract EthereumV2DPITest is BaseEthTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseEthTestV2(
      AaveV2EthereumAssets.DPI_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 19620358}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedEthereum.DPItoETHAdapterCode()
      })
    )
  {}
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';

contract AaveV2EthereumPayload is IProposalGenericExecutor {
  struct Adapters {
    address usdtAdapter;
    address usdcAdapter;
    address daiAdapter;
    address usdpAdapter;
    address fraxAdapter;
    address tusdAdapter;
    address lusdAdapter;
    address busdAdapter;
    address susdAdapter;
    address ustAdapter;
    address dpiAdapter;
    // address amplAdapter;
  }

  address public immutable USDT_ADAPTER;
  address public immutable USDC_ADAPTER;
  address public immutable DAI_ADAPTER;
  address public immutable USDP_ADAPTER;
  address public immutable FRAX_ADAPTER;
  address public immutable TUSD_ADAPTER;
  address public immutable LUSD_ADAPTER;
  address public immutable BUSD_ADAPTER;
  address public immutable SUSD_ADAPTER;
  address public immutable UST_ADAPTER;
  address public immutable DPI_ADAPTER;

  // address public immutable AMPL_ADAPTER;

  constructor(Adapters memory adapters) {
    USDT_ADAPTER = adapters.usdtAdapter;
    USDC_ADAPTER = adapters.usdcAdapter;
    DAI_ADAPTER = adapters.daiAdapter;
    USDP_ADAPTER = adapters.usdpAdapter;
    FRAX_ADAPTER = adapters.fraxAdapter;
    TUSD_ADAPTER = adapters.tusdAdapter;
    LUSD_ADAPTER = adapters.lusdAdapter;
    BUSD_ADAPTER = adapters.busdAdapter;
    SUSD_ADAPTER = adapters.susdAdapter;
    UST_ADAPTER = adapters.ustAdapter;
    DPI_ADAPTER = adapters.dpiAdapter;
    // AMPL_ADAPTER = adapters.amplAdapter;
  }

  function execute() external {
    address[] memory assets = new address[](11);
    address[] memory sources = new address[](11);

    assets[0] = AaveV2EthereumAssets.USDT_UNDERLYING;
    sources[0] = USDT_ADAPTER;

    assets[1] = AaveV2EthereumAssets.USDC_UNDERLYING;
    sources[1] = USDC_ADAPTER;

    assets[2] = AaveV2EthereumAssets.DAI_UNDERLYING;
    sources[2] = DAI_ADAPTER;

    assets[3] = AaveV2EthereumAssets.USDP_UNDERLYING;
    sources[3] = USDP_ADAPTER;

    assets[4] = AaveV2EthereumAssets.FRAX_UNDERLYING;
    sources[4] = FRAX_ADAPTER;

    assets[5] = AaveV2EthereumAssets.TUSD_UNDERLYING;
    sources[5] = TUSD_ADAPTER;

    assets[6] = AaveV2EthereumAssets.LUSD_UNDERLYING;
    sources[6] = LUSD_ADAPTER;

    assets[7] = AaveV2EthereumAssets.BUSD_UNDERLYING;
    sources[7] = BUSD_ADAPTER;

    assets[8] = AaveV2EthereumAssets.sUSD_UNDERLYING;
    sources[8] = SUSD_ADAPTER;

    assets[9] = AaveV2EthereumAssets.UST_UNDERLYING;
    sources[9] = UST_ADAPTER;

    assets[10] = AaveV2EthereumAssets.DPI_UNDERLYING;
    sources[10] = DPI_ADAPTER;

    AaveV2Ethereum.ORACLE.setAssetSources(assets, sources);
  }
}

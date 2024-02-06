// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregatorsMainnet.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {CbETHPriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CbETHPriceCapAdapter.sol';
import {RETHPriceCapAdapter} from '../src/contracts/RETHPriceCapAdapter.sol';
import {WstETHPriceCapAdapter} from '../src/contracts/WstETHPriceCapAdapter.sol';
import {SDAIPriceCapAdapter} from '../src/contracts/SDAIPriceCapAdapter.sol';
import {AaveV3EthereumPayload} from '../src/contracts/payloads/AaveV3EthereumPayload.sol';

library CapAdaptersStablesCodeEthereum {
  bytes public constant USDT_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.USDT_ORACLE,
        'Capped USDT/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant DAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.DAI_ORACLE,
        'Capped DAI/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant LUSD_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.LUSD_ORACLE,
        'Capped LUSD/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant FRAX_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.FRAX_ORACLE,
        'Capped FRAX/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant crvUSD_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.crvUSD_ORACLE,
        'Capped crvUSD/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
}

library CapAdaptersCodeEthereum {
  bytes public constant sDAI_ADAPTER_CODE =
    abi.encodePacked(
      type(SDAIPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.DAI_ORACLE,
        BaseAggregatorsMainnet.SDAI_POT,
        'Capped sDAI / DAI / USD',
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
  bytes public constant cbETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CbETHPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.WETH_ORACLE,
        AaveV3EthereumAssets.cbETH_UNDERLYING,
        'Capped cbETH / ETH / USD',
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
  bytes public constant rETH_ADAPTER_CODE =
    abi.encodePacked(
      type(RETHPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.WETH_ORACLE,
        AaveV3EthereumAssets.rETH_UNDERLYING,
        'Capped rETH / ETH / USD',
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(WstETHPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.WETH_ORACLE,
        AaveV2EthereumAssets.stETH_UNDERLYING,
        'Capped wstETH / stETH(ETH) / USD', // TODO: is it actually going to STETH, but then using ETH feed
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
}

contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    AaveV3EthereumPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersStablesCodeEthereum.USDT_ADAPTER_CODE
    );
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersStablesCodeEthereum.USDC_ADAPTER_CODE
    );
    adapters.daiAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersStablesCodeEthereum.DAI_ADAPTER_CODE
    );
    adapters.sDaiAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeEthereum.sDAI_ADAPTER_CODE
    );
    adapters.lusdAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersStablesCodeEthereum.LUSD_ADAPTER_CODE
    );
    adapters.fraxAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersStablesCodeEthereum.FRAX_ADAPTER_CODE
    );
    adapters.crvUsdAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersStablesCodeEthereum.crvUSD_ADAPTER_CODE
    );
    adapters.cbEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeEthereum.cbETH_ADAPTER_CODE
    );
    adapters.rEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeEthereum.rETH_ADAPTER_CODE
    );
    adapters.wstEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeEthereum.wstETH_ADAPTER_CODE
    );

    GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3EthereumPayload).creationCode, abi.encode(adapters))
    );
  }
}

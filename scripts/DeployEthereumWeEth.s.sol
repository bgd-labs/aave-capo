// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book-latest/AaveV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book-latest/MiscEthereum.sol';

import {IPriceCapAdapter} from '../src/interfaces/IPriceCapAdapter.sol';
import {WeETHPriceCapAdapter} from '../src/contracts/WeETHPriceCapAdapter.sol';

library CapAdaptersCodeEthereum {
  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(WeETHPriceCapAdapter).creationCode,
        abi.encode(
          AaveV3Ethereum.ACL_MANAGER,
          AaveV3EthereumAssets.WETH_ORACLE,
          MiscEthereum.weETH_RATIO_PROVIDER,
          'Capped weETH / eETH(ETH) / USD',
          7 days,
          IPriceCapAdapter.PriceCapUpdateParams({
            snapshotRatio: 1034656878645040505,
            snapshotTimestamp: 1711416299, // 26-03-2024
            maxYearlyRatioGrowthPercent: 8_75
          })
        )
      );
  }
}

contract DeployWeEthEthereum is EthereumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeEthereum.weETHAdapterCode());
  }
}

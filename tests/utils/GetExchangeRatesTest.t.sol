// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';
import {AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';
import {MiscBase} from 'aave-address-book/MiscBase.sol';
import {MiscGnosis} from 'aave-address-book/MiscGnosis.sol';
import {MiscOptimism} from 'aave-address-book/MiscOptimism.sol';
import {MiscPolygon} from 'aave-address-book/MiscPolygon.sol';

import {ICbEthRateProvider} from 'cl-synchronicity-price-adapter/interfaces/ICbEthRateProvider.sol';
import {IrETH} from 'cl-synchronicity-price-adapter/interfaces/IrETH.sol';
import {IPot} from 'cl-synchronicity-price-adapter/interfaces/IPot.sol';
import {IStETH} from 'cl-synchronicity-price-adapter/interfaces/IStETH.sol';
import {IMaticRateProvider} from 'cl-synchronicity-price-adapter/interfaces/IMaticRateProvider.sol';
import {IERC4626} from 'forge-std/interfaces/IERC4626.sol';
import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';
import {ISAvax} from '../../src/interfaces/ISAvax.sol';
import {IStEUR} from '../../src/interfaces/IStEUR.sol';

contract ExchangeRatesEth is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19233700); // 15th of February days ago
  }

  function test_getExchangeRate() public {
    uint256 cbEthRate = ICbEthRateProvider(AaveV3EthereumAssets.cbETH_UNDERLYING).exchangeRate();
    uint256 rEthRate = IrETH(AaveV3EthereumAssets.rETH_UNDERLYING).getExchangeRate();
    uint256 sDaiRate = IPot(MiscEthereum.sDAI_POT).chi();
    uint256 wstEthRate = IStETH(AaveV2EthereumAssets.stETH_UNDERLYING).getPooledEthByShares(
      10 ** 18
    );
    uint256 stEurRate = IStEUR(MiscEthereum.stEUR).convertToAssets(10 ** 18);

    console.log('cbEthRate', cbEthRate);
    console.log('rEthRate', rEthRate);
    console.log('sDaiRate', sDaiRate);
    console.log('wstEthRate', wstEthRate);
    console.log('stEurRate', stEurRate);

    console.log(block.timestamp);
  }
}

contract ExchangeRatesArbitrum is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 180866340); // 15th of February
  }

  function test_getExchangeRate() public {
    uint256 rEthRate = uint256(
      IChainlinkAggregator(MiscArbitrum.rETH_ETH_AGGREGATOR).latestAnswer()
    );
    uint256 wstEthRate = uint256(
      IChainlinkAggregator(MiscArbitrum.wstETH_stETH_AGGREGATOR).latestAnswer()
    );

    console.log('Arbitrum');
    console.log('rEthRate', rEthRate);
    console.log('wstEthRate', wstEthRate);
    console.log(block.timestamp);
  }
}

contract ExchangeRatesAvax is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 41384761); // 7th of February
  }

  function test_getExchangeRate() public {
    uint256 sAvaxRate = ISAvax(AaveV3AvalancheAssets.sAVAX_UNDERLYING).getPooledAvaxByShares(
      10 ** 18
    );

    console.log('Avalanche');
    console.log('sAvaxRate', sAvaxRate);

    console.log(block.timestamp);
  }
}

contract ExchangeRatesBase is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('base'), 10586628); // 15th of February
  }

  function test_getExchangeRate() public {
    uint256 cbEthRate = uint256(IChainlinkAggregator(MiscBase.cbETH_ETH_AGGREGATOR).latestAnswer());
    uint256 wstEthRate = uint256(
      IChainlinkAggregator(MiscBase.wstETH_stETH_AGGREGATOR).latestAnswer()
    );

    console.log('Base');
    console.log('cbEthRate', cbEthRate);
    console.log('wstEthRate', wstEthRate);

    console.log(block.timestamp);
  }
}

contract ExchangeRatesGnosis is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('gnosis'), 32462055); // 15th of February
  }

  function test_getExchangeRate() public {
    uint256 sDaiRate = IERC4626(AaveV3GnosisAssets.sDAI_UNDERLYING).convertToAssets(10 ** 18);
    uint256 wstEthRate = uint256(
      IChainlinkAggregator(MiscGnosis.wstETH_stETH_AGGREGATOR).latestAnswer()
    );

    console.log('Gnosis');
    console.log('sDaiRate', sDaiRate);
    console.log('wstEthRate', wstEthRate);

    console.log(block.timestamp);
  }
}

contract ExchangeRatesOptimism is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 116196954); // 15th of February
  }

  function test_getExchangeRate() public {
    uint256 rEthRate = uint256(
      IChainlinkAggregator(MiscOptimism.rETH_ETH_AGGREGATOR).latestAnswer()
    );
    uint256 wstEthRate = uint256(
      IChainlinkAggregator(MiscOptimism.wstETH_stETH_AGGREGATOR).latestAnswer()
    );

    console.log('Optimism');
    console.log('rEthRate', rEthRate);
    console.log('wstEthRate', wstEthRate);

    console.log(block.timestamp);
  }
}

contract ExchangeRates7Polygon is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 53527296); // 15th of February days ago
  }

  function test_getExchangeRate() public {
    uint256 wstEthRate = uint256(
      IChainlinkAggregator(MiscPolygon.wstETH_stETH_AGGREGATOR).latestAnswer()
    );

    console.log('Polygon 7');
    console.log('wstEthRate', wstEthRate);

    console.log(block.timestamp);
  }
}

contract ExchangeRates14Polygon is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 53252303); // 8th of February days ago
  }

  function test_getExchangeRate() public {
    uint256 stMaticRate = IMaticRateProvider(MiscPolygon.stMATIC_RATE_PROVIDER).getRate();
    uint256 maticXRate = IMaticRateProvider(MiscPolygon.MaticX_RATE_PROVIDER).getRate();

    console.log('Polygon 14');
    console.log('stMaticRate', stMaticRate);
    console.log('maticXRate', maticXRate);

    console.log(block.timestamp);
  }
}
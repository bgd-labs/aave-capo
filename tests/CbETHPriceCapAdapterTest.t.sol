// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {CbETHPriceCapAdapter, ICbEthRateProvider} from '../src/contracts/CbETHPriceCapAdapter.sol';
import {ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

contract CbETHPriceCapAdapterTest is Test {
  ICLSynchronicityPriceAdapter public constant notCappedAdapter =
    ICLSynchronicityPriceAdapter(AaveV3EthereumAssets.cbETH_ORACLE);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  //  function test_latestAnswer(uint16 maxPercent) public {
  //    CbETHPriceCapAdapter adapter = new CbETHPriceCapAdapter(
  //      AaveV3Ethereum.ACL_MANAGER,
  //      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
  //      BaseAggregatorsMainnet.CBETH,
  //      'cbETH / ETH / USD',
  //      // TODO: should be adjusted after we decide with source
  //      uint104(ICbEthRateProvider(BaseAggregatorsMainnet.CBETH).exchangeRate()),
  //      uint48(block.timestamp),
  //      maxPercent
  //    );
  //
  //    int256 price = adapter.latestAnswer();
  //    int256 priceOfNotCappedAdapter = notCappedAdapter.latestAnswer();
  //
  //    assertEq(price, priceOfNotCappedAdapter);
  //  }

  function test_cappedLatestAnswer() public {
    CbETHPriceCapAdapter adapter = new CbETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      BaseAggregatorsMainnet.CBETH,
      'cbETH / ETH / USD',
      1059523963000000000,
      1703743921,
      2_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      235982310000, // max growth 2%
      100000000
    );
  }
}

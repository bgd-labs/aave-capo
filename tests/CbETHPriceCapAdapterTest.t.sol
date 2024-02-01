// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {CbETHPriceCapAdapter, ICbEthRateProvider} from '../src/contracts/CbETHPriceCapAdapter.sol';
import {ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

contract CbETHPriceCapAdapterTest is BaseTest {
  constructor() BaseTest(AaveV3EthereumAssets.cbETH_ORACLE) {}

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public override returns (IPriceCapAdapter) {
    return
      new CbETHPriceCapAdapter(
        aclManager,
        baseAggregatorAddress,
        ratioProviderAddress,
        pairDescription,
        minimumSnapshotDelay,
        priceCapParams
      );
  }

  function createAdapterSimple(
    uint48 minimumSnapshotDelay,
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      createAdapter(
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3EthereumAssets.WETH_ORACLE,
        AaveV3EthereumAssets.cbETH_UNDERLYING,
        'cbETH / ETH / USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(ICbEthRateProvider(AaveV3EthereumAssets.cbETH_UNDERLYING).exchangeRate());
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  function test_latestAnswer(uint16 maxYearlyRatioGrowthPercent) public override {
    IPriceCapAdapter adapter = createAdapterSimple(
      0,
      uint40(block.timestamp),
      maxYearlyRatioGrowthPercent
    );

    int256 price = adapter.latestAnswer();

    // here we have a very specific case, because we replace secondary-market based CL feed of exchange rate
    // with the primary cbETH based feed
    uint256 cbEthRate = getCurrentRatio();
    vm.mockCall(
      BaseAggregatorsMainnet.CBETH_ETH_AGGREGATOR,
      abi.encodeWithSelector(ICLSynchronicityPriceAdapter.latestAnswer.selector),
      abi.encode(int256(cbEthRate))
    );
    int256 priceOfNotCappedAdapter = NOT_CAPPED_ADAPTER.latestAnswer();

    assertEq(
      price,
      priceOfNotCappedAdapter,
      'uncapped price is not equal to the existing adapter price'
    );
  }

  function test_cappedLatestAnswer() public {
    IPriceCapAdapter adapter = createAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      AaveV3EthereumAssets.WETH_ORACLE,
      AaveV3EthereumAssets.cbETH_UNDERLYING,
      'cbETH / ETH / USD',
      7 days,
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

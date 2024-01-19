// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {RETHPriceCapAdapter, IrETH} from '../src/contracts/RETHPriceCapAdapter.sol';
import {MissingAssetsMainnet} from '../src/lib/MissingAssetsMainnet.sol';

contract RETHPriceCapAdapterTest is BaseTest {
  constructor() BaseTest(AaveV3EthereumAssets.rETH_ORACLE) {}

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      new RETHPriceCapAdapter(
        aclManager,
        baseAggregatorAddress,
        ratioProviderAddress,
        pairDescription,
        snapshotRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function createAdapterSimple(
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      new RETHPriceCapAdapter(
        AaveV3Ethereum.ACL_MANAGER,
        BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
        MissingAssetsMainnet.RETH,
        'rETH / ETH / USD',
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(IrETH(MissingAssetsMainnet.RETH).getExchangeRate());
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  function test_cappedLatestAnswer() public {
    RETHPriceCapAdapter adapter = new RETHPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.ETH_USD_AGGREGATOR,
      MissingAssetsMainnet.RETH,
      'rETH / ETH / USD',
      1093801647000000000,
      1703743921,
      2_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      243616800000, // max growth 2%
      100000000
    );
  }
}

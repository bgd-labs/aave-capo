// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {RETHPriceCapAdapter, IrETH} from '../../src/contracts/RETHPriceCapAdapter.sol';

contract RETHPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      AaveV3EthereumAssets.rETH_ORACLE,
      ForkParams({network: 'mainnet', blockNumber: 18961286}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_30,
        minimumSnapshotDelay: 7 days,
        startBlock: 18061286,
        finishBlock: 19183379,
        delayInBlocks: 50200,
        step: 20000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 18061286, finishBlock: 19183379})
    )
  {}

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public override returns (IPriceCapAdapter) {
    return
      new RETHPriceCapAdapter(
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
        AaveV3EthereumAssets.rETH_UNDERLYING,
        'rETH / ETH / USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(IrETH(AaveV3EthereumAssets.rETH_UNDERLYING).getExchangeRate());
  }
}

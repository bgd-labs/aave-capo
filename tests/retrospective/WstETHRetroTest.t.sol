// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseRetroTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets, IACLManager} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {WstETHPriceCapAdapter, IStETH} from '../../src/contracts/WstETHPriceCapAdapter.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';

contract WstETHRetroTest is BaseRetroTest {
  constructor()
    BaseRetroTest(AaveV3EthereumAssets.wstETH_ORACLE, 9_10, 7 days, 19183379, 200000, 50000)
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
      new WstETHPriceCapAdapter(
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
        AaveV2EthereumAssets.stETH_UNDERLYING,
        'wstETH/stETH/USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return
      uint104(
        uint256(IStETH(AaveV2EthereumAssets.stETH_UNDERLYING).getPooledEthByShares(10 ** 18))
      );
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18061286);
  }
}

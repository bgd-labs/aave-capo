// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {MiscEthereum} from 'aave-address-book/MiscEthereum.sol';

import {CbETHPriceCapAdapter, ICbEthRateProvider} from '../../src/contracts/CbETHPriceCapAdapter.sol';
import {ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract CbETHPriceCapAdapterTest is BaseTest {
  address cbETH_ETH_AGGREGATOR = 0xF017fcB346A1885194689bA23Eff2fE6fA5C483b;

  constructor()
    BaseTest(
      AaveV3EthereumAssets.cbETH_ORACLE,
      CapAdaptersCodeEthereum.cbETH_ADAPTER_CODE,
      ForkParams({network: 'mainnet', blockNumber: 19368742}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 8_12,
        minimumSnapshotDelay: 7 days,
        startBlock: 18061286,
        finishBlock: 19368742,
        delayInBlocks: 50200,
        step: 200000
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

  function _mockExistingOracleExchangeRate() internal override {
    uint256 cbEthRate = getCurrentRatio();
    vm.mockCall(
      cbETH_ETH_AGGREGATOR,
      abi.encodeWithSelector(ICLSynchronicityPriceAdapter.latestAnswer.selector),
      abi.encode(int256(cbEthRate))
    );
  }
}

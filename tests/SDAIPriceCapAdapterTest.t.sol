// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import './BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {BaseAggregatorsMainnet} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {SDAIPriceCapAdapter, IPot} from '../src/contracts/SDAIPriceCapAdapter.sol';

contract SDAIPriceCapAdapterTest is BaseTest {
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
      new SDAIPriceCapAdapter(
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
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      new SDAIPriceCapAdapter(
        AaveV3Ethereum.ACL_MANAGER,
        BaseAggregatorsMainnet.DAI_USD_AGGREGATOR,
        BaseAggregatorsMainnet.SDAI_POT,
        'sDAI / DAI / USD',
        getCurrentRatio(),
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return uint104(IPot(BaseAggregatorsMainnet.SDAI_POT).chi());
  }

  function getCurrentNotCappedPrice() public view override returns (int256) {
    return notCappedAdapter.latestAnswer();
  }

  ICLSynchronicityPriceAdapter public constant notCappedAdapter =
    ICLSynchronicityPriceAdapter(AaveV3EthereumAssets.sDAI_ORACLE);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18961286);
  }

  function test_cappedLatestAnswer() public {
    SDAIPriceCapAdapter adapter = new SDAIPriceCapAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      BaseAggregatorsMainnet.DAI_USD_AGGREGATOR,
      BaseAggregatorsMainnet.SDAI_POT,
      'sDAI / DAI / USD',
      1048947230000000000000000000,
      1703743921,
      1_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      104911324, // max growth 2%
      100000000
    );
  }
}

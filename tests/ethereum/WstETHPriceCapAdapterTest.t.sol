// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Ethereum, AaveV3EthereumAssets, IACLManager} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';

import {WstETHPriceCapAdapter, IStETH} from '../../src/contracts/WstETHPriceCapAdapter.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract WstETHPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      AaveV3EthereumAssets.wstETH_ORACLE,
      CapAdaptersCodeEthereum.wstETH_ADAPTER_CODE,
      ForkParams({network: 'mainnet', blockNumber: 19368742}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_68,
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

  function test_updateParameters_cappedLatestAnswer() public {
    IPriceCapAdapter adapter = createAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      AaveV3EthereumAssets.WETH_ORACLE,
      AaveV2EthereumAssets.stETH_UNDERLYING,
      'wstETH/stETH/USD',
      7 days,
      1151642949000000000,
      1703743921,
      2_00
    );

    int256 price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      256499500000, // max growth 2%
      100000000
    );

    vm.prank(AaveV3Ethereum.CAPS_PLUS_RISK_STEWARD);
    setCapParameters(adapter, 1151642955000000000, 1703743931, 20_00);

    price = adapter.latestAnswer();

    assertApproxEqAbs(
      uint256(price),
      256617830000, // value for selected block
      100000000
    );
  }

  function test_revert_updateParameters_notRiskAdmin(
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent,
    address admin
  ) public {
    vm.assume(admin != 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f);
    vm.assume(admin != 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    vm.assume(admin != AaveV3Ethereum.CAPS_PLUS_RISK_STEWARD);
    vm.assume(admin != address(AaveV3Ethereum.POOL_CONFIGURATOR));

    IPriceCapAdapter adapter = createAdapter(
      AaveV3Ethereum.ACL_MANAGER,
      AaveV3EthereumAssets.WETH_ORACLE,
      AaveV2EthereumAssets.stETH_UNDERLYING,
      'wstETH/stETH/USD',
      7 days,
      1151642949000000000,
      1703743921,
      2_00
    );

    vm.startPrank(admin);

    vm.expectRevert(IPriceCapAdapter.CallerIsNotRiskOrPoolAdmin.selector);
    setCapParameters(adapter, snapshotRatio, snapshotTimestamp, maxYearlyRatioGrowthPercent);

    vm.stopPrank();
  }
}

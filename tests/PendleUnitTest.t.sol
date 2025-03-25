// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'forge-std/Vm.sol';

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {IPendlePriceCapAdapter, ICLSynchronicityPriceAdapter, IChainlinkAggregator, IPendlePrincipalToken} from '../src/interfaces/IPendlePriceCapAdapter.sol';
import {PendlePriceCapAdapter} from '../src/contracts/PendlePriceCapAdapter.sol';

contract TestAdapter is Test {
  MockChainlink assetToUsdAggregator;
  MockACL aclManager;
  MockPPT pptToken;

  PendlePriceCapAdapter pendleCapAdapter;

  address riskAdmin = address(0xDead);
  address poolAdmin = address(0xBeef);

  function setUp() public {
    assetToUsdAggregator = new MockChainlink();
    aclManager = new MockACL();
    pptToken = new MockPPT();

    assetToUsdAggregator.setLatestAnswer(1e8);
    aclManager.setAdmins(riskAdmin, poolAdmin);
    pptToken.setExpiry(block.timestamp + 30 days);
  }

  function test_construct() external {
    constr();

    assertEq(address(pendleCapAdapter.ASSET_TO_USD_AGGREGATOR()), address(assetToUsdAggregator));
    assertEq(address(pendleCapAdapter.PENDLE_PRINCIPAL_TOKEN()), address(pptToken));
    assertEq(pendleCapAdapter.MAX_DISCOUNT_RATE_PER_YEAR(), 3e17);
    assertEq(pendleCapAdapter.discountRatePerYear(), 2.5e17);
    assertEq(address(pendleCapAdapter.ACL_MANAGER()), address(aclManager));
    assertEq(pendleCapAdapter.description(), 'Pendle Capo Adapter');
    assertEq(pendleCapAdapter.decimals(), 8);
    assertEq(pendleCapAdapter.DECIMALS(), 8);
  }

  function test_constructRevert() external {
    IPendlePriceCapAdapter.PendlePriceCapAdapterParams memory params = IPendlePriceCapAdapter
      .PendlePriceCapAdapterParams({
        assetToUsdAggregator: address(0),
        pendlePrincipalToken: address(pptToken),
        maxDiscountRatePerYear: uint64(3e17), // 30%
        discountRatePerYear: uint64(2.5e17), // 25%
        aclManager: address(aclManager),
        description: 'Pendle Capo Adapter'
      });

    vm.expectRevert(abi.encodeWithSelector(IPendlePriceCapAdapter.ZeroAddress.selector));
    PendlePriceCapAdapter newPendleCapAdapter = new PendlePriceCapAdapter(params);

    params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
      assetToUsdAggregator: address(assetToUsdAggregator),
      pendlePrincipalToken: address(0),
      maxDiscountRatePerYear: uint64(3e17), // 30%
      discountRatePerYear: uint64(2.5e17), // 25%
      aclManager: address(aclManager),
      description: 'Pendle Capo Adapter'
    });

    vm.expectRevert(abi.encodeWithSelector(IPendlePriceCapAdapter.ZeroAddress.selector));
    newPendleCapAdapter = new PendlePriceCapAdapter(params);

    params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
      assetToUsdAggregator: address(assetToUsdAggregator),
      pendlePrincipalToken: address(pptToken),
      maxDiscountRatePerYear: uint64(0),
      discountRatePerYear: uint64(2.5e17), // 25%
      aclManager: address(aclManager),
      description: 'Pendle Capo Adapter'
    });

    vm.expectRevert(abi.encodeWithSelector(IPendlePriceCapAdapter.ZeroMaxDiscount.selector));
    newPendleCapAdapter = new PendlePriceCapAdapter(params);

    params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
      assetToUsdAggregator: address(assetToUsdAggregator),
      pendlePrincipalToken: address(pptToken),
      maxDiscountRatePerYear: uint64(3e17), // 30%
      discountRatePerYear: uint64(0),
      aclManager: address(aclManager),
      description: 'Pendle Capo Adapter'
    });

    vm.expectRevert(
      abi.encodeWithSelector(IPendlePriceCapAdapter.InvalidNewDiscountRatePerYear.selector)
    );
    newPendleCapAdapter = new PendlePriceCapAdapter(params);

    params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
      assetToUsdAggregator: address(assetToUsdAggregator),
      pendlePrincipalToken: address(pptToken),
      maxDiscountRatePerYear: uint64(3e17), // 30%
      discountRatePerYear: uint64(2.5e17), // 25%
      aclManager: address(0),
      description: 'Pendle Capo Adapter'
    });

    vm.expectRevert(abi.encodeWithSelector(IPendlePriceCapAdapter.ZeroAddress.selector));
    newPendleCapAdapter = new PendlePriceCapAdapter(params);

    params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
      assetToUsdAggregator: address(assetToUsdAggregator),
      pendlePrincipalToken: address(pptToken),
      maxDiscountRatePerYear: uint64(3e17), // 30%
      discountRatePerYear: uint64(3e17 + 1), // 30% + 1
      aclManager: address(aclManager),
      description: 'Pendle Capo Adapter'
    });

    vm.expectRevert(
      abi.encodeWithSelector(IPendlePriceCapAdapter.InvalidNewDiscountRatePerYear.selector)
    );
    newPendleCapAdapter = new PendlePriceCapAdapter(params);

    params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
      assetToUsdAggregator: address(assetToUsdAggregator),
      pendlePrincipalToken: address(pptToken),
      maxDiscountRatePerYear: uint64(13e18), // 1300%, 108% per month
      discountRatePerYear: uint64(13e18), // 1300%, 108% per month
      aclManager: address(aclManager),
      description: 'Pendle Capo Adapter'
    });

    vm.expectRevert(
      abi.encodeWithSelector(IPendlePriceCapAdapter.DiscountExceeds100Percent.selector)
    );
    newPendleCapAdapter = new PendlePriceCapAdapter(params);

    skip(1);

    pptToken.setExpiry(block.timestamp - 1);

    params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams({
      assetToUsdAggregator: address(assetToUsdAggregator),
      pendlePrincipalToken: address(pptToken),
      maxDiscountRatePerYear: uint64(3e17), // 30%
      discountRatePerYear: uint64(3e17), // 30%
      aclManager: address(aclManager),
      description: 'Pendle Capo Adapter'
    });

    vm.expectRevert(
      abi.encodeWithSelector(IPendlePriceCapAdapter.MaturityHasAlreadyPassed.selector)
    );
    newPendleCapAdapter = new PendlePriceCapAdapter(params);
  }

  function test_setDiscountRatePerYear(uint64 newDiscountRatePerYear) external {
    constr();

    vm.startPrank(poolAdmin);

    newDiscountRatePerYear = uint64(
      bound(newDiscountRatePerYear, 1, pendleCapAdapter.MAX_DISCOUNT_RATE_PER_YEAR())
    );

    pendleCapAdapter.setDiscountRatePerYear(newDiscountRatePerYear);

    assertEq(pendleCapAdapter.discountRatePerYear(), newDiscountRatePerYear);
  }

  function test_setDiscountRatePerYearRevert(uint64 newDiscountRatePerYear) external {
    constr();

    newDiscountRatePerYear = uint64(
      bound(
        newDiscountRatePerYear,
        pendleCapAdapter.MAX_DISCOUNT_RATE_PER_YEAR() + 1,
        type(uint64).max
      )
    );

    vm.startPrank(poolAdmin);

    vm.expectRevert(
      abi.encodeWithSelector(IPendlePriceCapAdapter.InvalidNewDiscountRatePerYear.selector)
    );
    pendleCapAdapter.setDiscountRatePerYear(newDiscountRatePerYear);
  }

  function test_latestAnswer(uint256 timeToSkip) external {
    constr();

    timeToSkip = bound(timeToSkip, 1, pendleCapAdapter.MATURITY() - block.timestamp);

    skip(timeToSkip);

    assertLe(pendleCapAdapter.latestAnswer(), assetToUsdAggregator.latestAnswer());
  }

  function test_latestAnswerBelow0() external {
    constr();

    assetToUsdAggregator.setLatestAnswer(-1);

    assertEq(pendleCapAdapter.latestAnswer(), 0);
  }

  function test_latestAnswerAfterMaturity(uint256 timeToSkip) external {
    constr();

    timeToSkip = bound(timeToSkip, pendleCapAdapter.MATURITY() - block.timestamp, type(uint64).max);

    skip(timeToSkip);

    assertEq(pendleCapAdapter.latestAnswer(), 1e8);
  }

  function test_getCurrentDiscount(uint256 timeToSkip) external {
    constr();

    timeToSkip = bound(timeToSkip, 1, pendleCapAdapter.MATURITY() - block.timestamp);

    skip(timeToSkip);

    assertLe(pendleCapAdapter.getCurrentDiscount(), pendleCapAdapter.MAX_DISCOUNT_RATE_PER_YEAR());
  }

  function test_getCurrentDiscountAfterMaturity(uint256 timeToSkip) external {
    constr();

    timeToSkip = bound(timeToSkip, pendleCapAdapter.MATURITY() - block.timestamp, type(uint64).max);

    skip(timeToSkip);

    assertEq(pendleCapAdapter.getCurrentDiscount(), 0);
  }

  function test_setCurrentDiscount() external {
    constr();

    address someone = address(0xBad);

    vm.startPrank(someone);

    vm.expectRevert(
      abi.encodeWithSelector(IPendlePriceCapAdapter.CallerIsNotRiskOrPoolAdmin.selector)
    );
    pendleCapAdapter.setDiscountRatePerYear(1);

    vm.stopPrank();
    vm.startPrank(poolAdmin);

    pendleCapAdapter.setDiscountRatePerYear(1);

    vm.stopPrank();
    vm.startPrank(riskAdmin);

    pendleCapAdapter.setDiscountRatePerYear(1);
  }

  function constr() public {
    IPendlePriceCapAdapter.PendlePriceCapAdapterParams memory params = IPendlePriceCapAdapter
      .PendlePriceCapAdapterParams({
        assetToUsdAggregator: address(assetToUsdAggregator),
        pendlePrincipalToken: address(pptToken),
        maxDiscountRatePerYear: uint64(3e17), // 30%
        discountRatePerYear: uint64(2.5e17), // 25%
        aclManager: address(aclManager),
        description: 'Pendle Capo Adapter'
      });

    pendleCapAdapter = new PendlePriceCapAdapter(params);
  }
}

contract MockPPT {
  uint256 public expiry;

  function setExpiry(uint256 expiry_) external {
    expiry = expiry_;
  }
}

contract MockChainlink {
  int256 public latestAnswer;

  function setLatestAnswer(int256 price_) external {
    latestAnswer = price_;
  }

  function decimals() external pure returns (uint8) {
    return 8;
  }
}

contract MockACL {
  address riskAdmin;
  address poolAdmin;

  function setAdmins(address risk, address pool) external {
    riskAdmin = risk;
    poolAdmin = pool;
  }

  function isRiskAdmin(address isRisk) external view returns (bool) {
    return isRisk == riskAdmin;
  }

  function isPoolAdmin(address isPool) external view returns (bool) {
    return isPool == poolAdmin;
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseStableTest.sol';
import {PriceCapAdapterStable} from '../../src/contracts/PriceCapAdapterStable.sol';
import {CapAdaptersCodeEthereum} from '../../scripts/DeployEthereum.s.sol';
import {CapAdaptersCodeInk} from '../../scripts/DeployInk.s.sol';
import {CapAdaptersCodeLinea} from '../../scripts/DeployLinea.s.sol';
import {CapAdaptersCodeMantle} from '../../scripts/DeployMantle.s.sol';
import {CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';
import {CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrum.s.sol';
import {CapAdaptersCodeXLayer} from '../../scripts/DeployXLayer.s.sol';
import {CapAdaptersCodeMonad} from '../../scripts/DeployMonad.s.sol';

contract USDCEthereumTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeEthereum.USDCAdapterCode(),
      14,
      ForkParams({network: 'mainnet', blockNumber: 22195655})
    )
  {}
}

contract USDCInkTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeInk.USDCAdapterCode(),
      10,
      ForkParams({network: 'ink', blockNumber: 30822600})
    )
  {}
}

contract USDCLineaTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeLinea.USDCAdapterCode(),
      10,
      ForkParams({network: 'linea', blockNumber: 13432357})
    )
  {}
}

contract USDCMantleTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeMantle.USDCAdapterCode(),
      30,
      ForkParams({network: 'mantle', blockNumber: 90209274})
    )
  {}
}

contract USDCBaseTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeBase.USDCAdapterCode(),
      14,
      ForkParams({network: 'base', blockNumber: 42567000})
    )
  {}
}

contract USDCArbitrumTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeArbitrum.USDCAdapterCode(),
      30,
      ForkParams({network: 'arbitrum', blockNumber: 435534000})
    )
  {}
}

contract USDCXlayerTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeXLayer.USDCAdapterCode(),
      30,
      ForkParams({network: 'xlayer', blockNumber: 68890000})
    )
  {}
}

contract USDCMonadTest is BaseStableTest {
  constructor()
    BaseStableTest(
      CapAdaptersCodeMonad.USDCAdapterCode(),
      0,
      ForkParams({network: 'monad', blockNumber: 83150000})
    )
  {}

  function setUp() public override {
    super.setUp();
    GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMonad.scaledAdapterCode(CapAdaptersCodeMonad.USDC_SVR_USD_PRICE_FEED)
    );
  }

  function test_latestAnswerRetrospective() public pure override {
    // base feed is a freshly deployed ScaledPriceAdapter over the SVR feed
    assertTrue(true);
  }
}

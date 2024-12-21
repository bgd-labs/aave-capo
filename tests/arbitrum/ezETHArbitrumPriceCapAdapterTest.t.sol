// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';

import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrum.s.sol';

contract ezETHArbitrumPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      CapAdaptersCodeArbitrum.ezETHAdapterCode(),
      90,
      ForkParams({network: 'arbitrum', blockNumber: 286888946}),
      'ezETH_arbitrum'
    )
  {}
}

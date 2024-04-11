// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseTestV2} from './BaseTestV2.sol';
import {IPriceCapAdapterStable, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapterStable.sol';

import {CapAdaptersCodeAvalanche} from '../../scripts/AaveV2/DeployAvalanche.s.sol';

contract AvalancheV2USDTTest is BaseTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseTestV2(
      AaveV2AvalancheAssets.USDTe_ORACLE,
      ForkParams({network: 'avalanche', blockNumber: 44060422}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: CapAdaptersCodeAvalanche.USDTCappedAdapterCode()
      })
    )
  {}
}

contract AvalancheV2USDCTest is BaseTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseTestV2(
      AaveV2AvalancheAssets.USDCe_ORACLE,
      ForkParams({network: 'avalanche', blockNumber: 44060422}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: CapAdaptersCodeAvalanche.USDCCappedAdapterCode()
      })
    )
  {}
}

contract AvalancheV2DAITest is BaseTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BaseTestV2(
      AaveV2AvalancheAssets.DAIe_ORACLE,
      ForkParams({network: 'avalanche', blockNumber: 44060422}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: CapAdaptersCodeAvalanche.DAICappedAdapterCode()
      })
    )
  {}
}

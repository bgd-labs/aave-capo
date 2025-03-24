// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.20;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';
import {IOsGNO} from '../../interfaces/IOsGNO.sol';

/**
 * @title OsGNOPriceCapAdapter
 * @author Aave-Chan Initiative
 * @notice Price capped adapter to calculate price of (osGNO / USD) pair by using
 * @notice Chainlink data feed for (GNO / USD) and (osGNO / GNO) ratio.
 */
contract OsGNOPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param capAdapterParams parameters to create cap adapter
   */
  constructor(
    CapAdapterParams memory capAdapterParams
  )
    PriceCapAdapterBase(
      CapAdapterBaseParams({
        aclManager: capAdapterParams.aclManager,
        baseAggregatorAddress: capAdapterParams.baseAggregatorAddress,
        ratioProviderAddress: capAdapterParams.ratioProviderAddress,
        pairDescription: capAdapterParams.pairDescription,
        ratioDecimals: 18,
        minimumSnapshotDelay: capAdapterParams.minimumSnapshotDelay,
        priceCapParams: capAdapterParams.priceCapParams
      })
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IOsGNO(RATIO_PROVIDER).getRate());
  }
}

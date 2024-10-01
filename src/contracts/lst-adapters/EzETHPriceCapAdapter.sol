// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';

import {IEzETHRestakeManager, IEzEthToken} from '../../interfaces/IEzETH.sol';

/**
 * @title EzETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (ezETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (ezETH / ETH) ratio.
 */
contract EzETHPriceCapAdapter is PriceCapAdapterBase {
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

  function getRatio() public view override returns (int256) {
    (, , uint256 totalTVL) = IEzETHRestakeManager(RATIO_PROVIDER).calculateTVLs();
    uint256 totalSupply = IEzETHRestakeManager(RATIO_PROVIDER).ezETH().totalSupply();
    /**  
     * @dev Below, we are doing exactly what the 
      `function calculateRedeemAmount(
            uint256 ezETHAmount,
            uint256 ezETHSupply,
            uint256 totalTVL
        ) external pure returns (uint256)` does in the Renzo Oracle contract, 
     * so we are avoiding an unnecessary extra external call.
     */
    return int256(((totalTVL * 1 ether) / totalSupply));
  }
}

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
 * @dev IMPORTANT: The `calculateTVLs` function called in the `RATIO_PROVIDER` is used to calculate the total assets deposited within the system
 * (operators and Withdraw contract), and those type of calculations needs to use some type of virtual accounting to avoid the well-known 'donation attacks'.
 * In one of the calls inside the `calculateTVLs`, there is a usage of `balanceOf`(specifically in the calculation of LSTs in the Withdraw contract)
 * being subject to a donation attack. But it's understood that, exclusively in this case, the donations cannot cause a 'completed' manipulation because
 * the token donated cannot be rescued after the donation and can be considered as an 'injection of rewards', which would benefit all ezETH shareholders. Also,
 * it is important to mention that the Aave Protocol does not allow the ezETH to be borrowed in its system, which limits any benefit to the attacker from the 'possible'
 * manipulation of the exchange rate. Other systems using this oracle should consider and evaluate those risks described here.
 * More information can be found in the ezETH discussion in the forum: https://governance.aave.com/t/arfc-onboard-ezeth-to-aave-v3-lido-instance/18504/9#p-48707-asset-pricing-13
 */
contract EzETHPriceCapAdapter is PriceCapAdapterBase {
  IEzEthToken internal constant ezETH = IEzEthToken(0xbf5495Efe5DB9ce00f80364C8B423567e58d2110);

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
    /**
     * @dev Below, we are doing exactly what the
      `function calculateRedeemAmount(
            uint256 ezETHAmount,
            uint256 ezETHSupply,
            uint256 totalTVL
        ) external pure returns (uint256)` does in the Renzo Oracle contract,
     * so we are avoiding an unnecessary extra external call.
     */
    return int256(((totalTVL * 1 ether) / ezETH.totalSupply()));
  }
}

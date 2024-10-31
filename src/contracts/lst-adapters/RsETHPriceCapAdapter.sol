// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';

import {IRsETH} from '../../interfaces/IRsETH.sol';

/**
 * @title RsETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (rsETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (rsETH / ETH) ratio.
 * @dev IMPORTANT: The `rsETHPrice()` function called in the `RATIO_PROVIDER` is a storage variable that updates the exchange rate for rsETH.
 * This variable is updated via the `updateRSETHPrice` function, which internally calculates using the formula: `staked assets value in ETH / rsETH.totalSupply()`.
 * To calculate the staked assets value in ETH, the `getTotalAssetDeposits()` function is called in the rsETH DepositPool contract(0x036676389e48133B63a802f8635AD39E752D375D).
 * It internally calls the `getAssetDistributionData(asset)` to obtain the balances via the `asset.balanceOf()` function, meaning that the exchange rate of rsETH can be
 * manipulated by inflating its price via the donation of these assets. But it's understood that, exclusively in this case, the donations cannot cause a 'completed' manipulation because
 * the token donated cannot be rescued after the donation and can be considered as an 'injection of rewards', which would benefit all rsETH shareholders. Also,
 * it is important to mention that the Aave Protocol does not allow the rsETH to be borrowed in its system (this restriction has been in place since the asset's listing, but it may/could change in the future if the governance decides otherwise.), which limits any benefit to the attacker from the 'possible'
 * manipulation of the exchange rate. Other systems using this oracle should consider and evaluate those risks described here.
 * More information can be found in the rsETH discussion in the forum: https://governance.aave.com/t/arfc-add-rseth-to-aave-v3-ethereum/17696/16
 */
contract RsETHPriceCapAdapter is PriceCapAdapterBase {
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
    return int256(IRsETH(RATIO_PROVIDER).rsETHPrice());
  }
}

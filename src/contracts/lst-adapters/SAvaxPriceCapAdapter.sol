// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';
import {ISAvax} from '../../interfaces/ISAvax.sol';

/**
 * @title SAvaxPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (sAVAX / USD) pair by using
 * @notice Chainlink data feed for (AVAX / USD) and (sAVAX / AVAX) ratio.
 */
contract SAvaxPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param avaxToBaseAggregatorAddress the address of (AVAX / USD) feed
   * @param sAVAXAddress the address of the sAVAX token, the (sAVAX / AVAX) ratio feed
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param priceCapParams parameters to set price cap
   */
  constructor(
    IACLManager aclManager,
    address avaxToBaseAggregatorAddress,
    address sAVAXAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    PriceCapUpdateParams memory priceCapParams
  )
    PriceCapAdapterBase(
      aclManager,
      avaxToBaseAggregatorAddress,
      sAVAXAddress,
      pairName,
      18,
      minimumSnapshotDelay,
      priceCapParams
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(ISAvax(RATIO_PROVIDER).getPooledAvaxByShares(10 ** RATIO_DECIMALS));
  }
}

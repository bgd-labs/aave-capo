// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';
import {ISAvax} from '../interfaces/ISAvax.sol';

/**
 * @title SAvaxPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (sAVAX / USD) pair by using
 * @notice Chainlink data feed for (AVAX / USD) and (sAVAX / AVAX) ratio.
 */
contract SAvaxPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice sAvax contract
   */
  ISAvax public immutable SAVAX;

  /**
   * @param avaxToBaseAggregatorAddress the address of cbETH / BASE feed
   * @param sAvaxAddress the address of the rETH token
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address avaxToBaseAggregatorAddress,
    address sAvaxAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      avaxToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    SAVAX = ISAvax(sAvaxAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = int256(SAVAX.getPooledAvaxByShares(1 ether));

    return ratio;
  }
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';
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
   * @param aclManager ACL manager contract
   * @param avaxToBaseAggregatorAddress the address of (AVAX / USD) feed
   * @param sAVAXAddress the address of the sAVAX token, the (sAVAX / AVAX) ratio feed
   * @param pairName name identifier
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address avaxToBaseAggregatorAddress,
    address sAVAXAddress,
    string memory pairName,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      avaxToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {
    SAVAX = ISAvax(sAVAXAddress);
  }

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(SAVAX.getPooledAvaxByShares(1 ether)); // TODO: RATIO_DECIMALS should be used ??
  }
}

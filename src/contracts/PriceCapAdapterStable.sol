// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IPriceCapAdapterStable, ICLSynchronicityPriceAdapter, IACLManager, IChainlinkAggregator} from '../interfaces/IPriceCapAdapterStable.sol';

/**
 * @title PriceCapAdapterStable
 * @author BGD Labs
 * @notice Price adapter to cap the price of the USD pegged assets
 */
contract PriceCapAdapterStable is IPriceCapAdapterStable {
  /// @inheritdoc IPriceCapAdapterStable
  IChainlinkAggregator public immutable ASSET_TO_USD_AGGREGATOR;

  /// @inheritdoc IPriceCapAdapterStable
  IACLManager public immutable ACL_MANAGER;

  /// @inheritdoc ICLSynchronicityPriceAdapter
  uint8 public decimals;

  /// @inheritdoc ICLSynchronicityPriceAdapter
  string public description;

  int256 internal _priceCap;

  constructor(
    IACLManager aclManager,
    IChainlinkAggregator baseToUsdAggregator,
    string memory adapterDescription,
    int256 priceCap
  ) {
    ASSET_TO_USD_AGGREGATOR = baseToUsdAggregator;
    ACL_MANAGER = aclManager;
    description = adapterDescription;
    decimals = baseToUsdAggregator.decimals();

    _setPriceCap(priceCap);
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() external view override returns (int256) {
    int256 basePrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();

    if (basePrice > _priceCap) {
      return _priceCap;
    }

    return basePrice;
  }

  /// @inheritdoc IPriceCapAdapterStable
  function setPriceCap(int256 priceCap) external {
    if (!ACL_MANAGER.isRiskAdmin(msg.sender) && !ACL_MANAGER.isPoolAdmin(msg.sender)) {
      revert CallerIsNotRiskOrPoolAdmin();
    }

    _setPriceCap(priceCap);
  }

  /**
   * @notice Updates price cap
   * @param priceCap the new price cap
   */
  function _setPriceCap(int256 priceCap) internal {
    if (priceCap < 0) {
      revert NegativePrice(priceCap);
    }

    _priceCap = priceCap;

    emit PriceCapUpdated(priceCap);
  }
}

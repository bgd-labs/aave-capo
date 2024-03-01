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

  /**
   * @param aclManager ACL manager contract
   * @param assetToUsdAggregator the address of (underlyingAsset / USD) price feed
   * @param adapterDescription the capped (lstAsset / underlyingAsset) pair description
   * @param priceCap the price cap
   */
  constructor(
    IACLManager aclManager,
    IChainlinkAggregator assetToUsdAggregator,
    string memory adapterDescription,
    int256 priceCap
  ) {
    if (address(aclManager) == address(0)) {
      revert ACLManagerIsZeroAddress();
    }

    ASSET_TO_USD_AGGREGATOR = assetToUsdAggregator;
    ACL_MANAGER = aclManager;
    description = adapterDescription;
    decimals = assetToUsdAggregator.decimals();

    _setPriceCap(priceCap);
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() external view override returns (int256) {
    int256 basePrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();
    int256 priceCap = _priceCap;

    if (basePrice > priceCap) {
      return priceCap;
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

  /// @inheritdoc IPriceCapAdapterStable
  function isCapped() public view virtual returns (bool) {
    return (ASSET_TO_USD_AGGREGATOR.latestAnswer() > this.latestAnswer());
  }

  /**
   * @notice Updates price cap
   * @param priceCap the new price cap
   */
  function _setPriceCap(int256 priceCap) internal {
    int256 basePrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();

    if (priceCap < basePrice) {
      revert CapLowerThanActualPrice();
    }

    _priceCap = priceCap;

    emit PriceCapUpdated(priceCap);
  }
}

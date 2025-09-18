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

  /// @dev Update: Cap is moved here, cause it will take free space after address and will pack in 1 slot
  uint96 internal _priceCap;

  /// @inheritdoc IPriceCapAdapterStable
  IACLManager public immutable ACL_MANAGER;

  /// @inheritdoc ICLSynchronicityPriceAdapter
  uint8 public decimals;

  /// @inheritdoc ICLSynchronicityPriceAdapter
  string public description;

  /**
   * @param capAdapterStableParams parameters to create stable cap adapter
   */
  constructor(CapAdapterStableParams memory capAdapterStableParams) {
    if (address(capAdapterStableParams.aclManager) == address(0)) {
      revert ACLManagerIsZeroAddress();
    }

    ASSET_TO_USD_AGGREGATOR = capAdapterStableParams.assetToUsdAggregator;
    ACL_MANAGER = capAdapterStableParams.aclManager;
    description = capAdapterStableParams.adapterDescription;
    decimals = ASSET_TO_USD_AGGREGATOR.decimals();

    _setPriceCap(capAdapterStableParams.priceCap);
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() public view override returns (int256) {
    int256 basePrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();
    int256 priceCap = int256(uint256(_priceCap));

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
  function getPriceCap() external view returns (int256) {
    return int256(uint256(_priceCap));
  }

  /// @inheritdoc IPriceCapAdapterStable
  function isCapped() public view virtual returns (bool) {
    return ASSET_TO_USD_AGGREGATOR.latestAnswer() > int256(uint256(_priceCap));
  }

  /**
   * @notice Updates price cap
   * @param priceCap the new price cap
   */
  function _setPriceCap(int256 priceCap) internal {
    if (priceCap > int256(uint256(type(uint96).max))) {
      revert NewPriceCapIsTooHigh();
    }

    // Even if Aggregator is not active (but deployed) it will return at least 0, so priceCap can't be less than 0
    int256 basePrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();
    if (priceCap < basePrice) {
      revert CapLowerThanActualPrice();
    }

    _priceCap = uint96(uint256(priceCap));

    emit PriceCapUpdated(priceCap);
  }
}

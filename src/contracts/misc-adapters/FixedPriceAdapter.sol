// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IFixedPriceAdapter} from '../../interfaces/IFixedPriceAdapter.sol';

/**
 * @title FixedPriceAdapter
 * @author BGD Labs
 * @notice Price adapter using a fixed hardcoded price
 */
contract FixedPriceAdapter is IFixedPriceAdapter {
  /// @inheritdoc IFixedPriceAdapter
  uint8 public immutable DECIMALS;

  /// @inheritdoc IFixedPriceAdapter
  int256 public immutable PRICE;

  string internal _description;

  constructor (
    uint8 _decimals,
    int256 _price,
    string memory _adapterDescription
  ) {
    DECIMALS = _decimals;
    PRICE = _price;
    _description = _adapterDescription;
  }

  /// @inheritdoc IFixedPriceAdapter
  function description() external view returns (string memory) {
    return _description;
  }

  /// @inheritdoc IFixedPriceAdapter
  function decimals() external view returns (uint8) {
    return DECIMALS;
  }

  /// @inheritdoc IFixedPriceAdapter
  function latestAnswer() external view virtual returns (int256) {
    return PRICE;
  }
}

pragma solidity ^0.8.4;

// SPDX-License-Identifier: MIT  // Replace with your desired license

library FixedPointMath {
  /*
   * Fixed point representation with `fractionalBits` bits of decimals.
   *
   * This library defines a fixed-point data type that stores an integer
   * and allows for a certain number of decimal places. It provides basic
   * arithmetic operations and a basic square root function for fixed-point numbers.
   */

  uint256 public constant DECIMALS = 18; // This can be adjusted to your needs

  // Internal function to perform multiplication without overflow checks
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    return a * b;
  }

  // Internal function to perform division without overflow checks
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return a / b;
  }

  // Fixed-point multiplication with overflow check
  function mulDiv(uint256 a, uint256 b, uint256 denominator)
    internal
    pure
    returns (uint256)
  {
    // Perform multiplication
    uint256 product = mul(a, b);

    // Check for overflow (a * b) / denominator > MAX_UINT256
    if (product / denominator > type(uint256).max) {
      revert MulDivFailed("err"); // Custom error declaration
    }

    // Return the result after division
    return product / denominator;
  }

  // Custom error to indicate multiplication or division failure
  error MulDivFailed(string err);

  // Basic square root function for fixed-point numbers (limited accuracy)
  function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
      if (x == 0) return 0;

      uint256 z = (x + 1) / 2;
      uint256 y = x;

      while (z < y) {
        y = z;
        z = (x / z + z) / 2;
      }

      return y;
    }
  }
}

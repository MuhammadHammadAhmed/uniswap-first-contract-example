pragma solidity ^0.8.4;

// SPDX-License-Identifier: MIT  // Replace with your desired license

library TickMath {
  /*
   * Math library for handling tick calculations in Uniswap v3.
   *
   * This library provides functions to convert between ticks and sqrt price ratios
   * for Uniswap v3 pools.
   */

  // Minimum tick allowed by the pool
  uint24 public constant MIN_TICK = -887272;

  // Maximum tick allowed by the pool
  uint24 public constant MAX_TICK = -MIN_TICK;

  // Fixed point representation with 1.92 decimals
  uint256 public constant Q192 = 2**192;

  // Function to get the sqrt price ratio at a given tick
  function getSqrtRatioAtTick(int24 tick) internal pure returns (uint256) {
    unchecked {
      if (tick < MIN_TICK) {
        revert("Tick too low");
      } else if (tick > MAX_TICK) {
        revert("Tick too high");
      }

      uint256 absTick = uint256(tick < 0 ? -int24(tick) : tick);
      return sqrt(absTick << 192);
    }
  }

  // Square root function (unchecked, for fixed-point math)
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

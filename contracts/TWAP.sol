// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
//pragma solidity ^0.8.0;
import "hardhat/console.sol";

// Import Uniswap V3 interfaces
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";


contract TWAP {
  // Define the Uniswap V3 pool contract address for your desired token pair
 // address public poolAddress;

  constructor() {
        
    }

  // Function to fetch TWAP for a specific token pair and lookback period
  function getTwap(uint256 lookbackSeconds,address poolAddress) public view returns (
     int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s
    ) {
    // Get the current block timestamp
    uint32 currentBlockTimestamp = uint32(block.timestamp);

    // Calculate the starting timestamp for the lookback period
uint32[] memory timestamps = new uint32[](2);
timestamps[0] = 0;
timestamps[1] = 108;

    // Get the IUniswapV3Pool interface for the pool
    IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);

    // This function call retrieves historical price observations within the lookback period
        (
     int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s
    ) = pool.observe(timestamps);

    

    return (     tickCumulatives,  secondsPerLiquidityCumulativeX128s);
  }

  function priceFromTick(uint256 tick) public pure returns (uint256) {
  // Fixed point multiplication factor (1.0000000000000001)
  uint256 fixedOnePlus = 0x00000000010000000000000000000000000000000000000000000000000000001;

  // Convert tick to sqrtPriceX96
  uint256 sqrtPriceX96 = tick < 0 ? TickMath.getSqrtRatioAtTick(int24(tick)) : TickMath.getSqrtRatioAtTick(int24(tick + 1));

  // Convert sqrtPriceX96 to price (based on Uniswap V3 fixed point math)
  uint256 numerator = sqrtPriceX96 * sqrtPriceX96;
  uint256 denominator = fixedOnePlus * fixedOnePlus;
  return numerator / denominator;
}

}

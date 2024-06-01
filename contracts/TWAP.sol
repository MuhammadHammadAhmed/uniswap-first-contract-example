// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 



// Import Uniswap V3 interfaces
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

//import "./TickMath.sol";
//import "@uniswap/v3-core/contracts/libraries/FullMath.sol";


contract TWAP {
  // Define the Uniswap V3 pool contract address for your desired token pair
 // address public poolAddress;

  constructor() {
        
    }

  // Function to fetch TWAP for a specific token pair and lookback period
  function getTwap(uint256 lookbackSeconds,address poolAddress) public view returns (
     int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s,uint256[] memory _prices
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
//- for conversion

 uint256[] memory prices = new uint256[](timestamps.length);

 for (uint256 i = 1; i < timestamps.length; i++) {
  int24 averageTick = int24(
    (tickCumulatives[i] - tickCumulatives[i - 1]) / int160(secondsPerLiquidityCumulativeX128s[i])
  );
  prices[i] =1;// priceFromTick(averageTick);
}

    
    

    return (     tickCumulatives,  secondsPerLiquidityCumulativeX128s,prices);
  }

  function priceFromTick(int256 tick) public pure returns (uint256) {
  // Fixed point multiplication factor (1.0000000000000001)
  uint256 fixedOnePlus = 0x00000000010000000000000000000000000000000000000000000000000000001;

  // Convert tick to sqrtPriceX96
  uint256 sqrtPriceX96 =0;// tick < 0 ? TickMath.getSqrtRatioAtTick(int24(tick)) : TickMath.getSqrtRatioAtTick(int24(tick + 1));

  // Convert sqrtPriceX96 to price (based on Uniswap V3 fixed point math)
  uint256 numerator = sqrtPriceX96 * sqrtPriceX96;
  uint256 denominator = fixedOnePlus * fixedOnePlus;
  return  uint256(numerator / denominator);
}

// Create a Quoter instance
// IUniswapV3Quoter public constant quoter = IUniswapV3Quoter(0x....); // Replace with actual Quoter address

// // Get a quote for the amount of token out you would receive for a given amount of token in
// function getAmountOut(uint256 amountIn, address tokenIn, address tokenOut, uint24 fee) public view returns (uint256 amountOut) {
//   amountOut = quoter.quoteExactInputSingle(tokenIn, tokenOut, fee, amountIn, 0); // Specify minimum amount out (0 for any amount)
// }

// // Get a quote for the amount of token in you would need to swap to get a desired amount of token out
// function getAmountIn(uint256 amountOut, address tokenIn, address tokenOut, uint24 fee) public view returns (uint256 amountIn) {
//   amountIn = quoter.quoteExactOutputSingle(tokenIn, tokenOut, fee, amountOut, 0); // Specify maximum amount in (0 for any amount)
// }



}
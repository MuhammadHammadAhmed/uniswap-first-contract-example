// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 



// Import Uniswap V3 interfaces
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-periphery/contracts/interfaces/IQuoter.sol";
import "./UniswapV3TickPriceConverter.sol";




contract TWAP {
  // Define the Uniswap V3 pool contract address for your desired token pair
 // address public poolAddress;

  constructor() {
        
    }

  // Function to fetch TWAP for a specific token pair and lookback period
  function getTwap(uint32 lookbackSeconds,address poolAddress) public view returns (
     int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s,uint256[] memory _prices
    ) {
    // Get the current block timestamp
    uint32 currentBlockTimestamp = uint32(block.timestamp);

    // Calculate the starting timestamp for the lookback period
uint32[] memory timestamps = new uint32[](2);
timestamps[0] = 0;
timestamps[1] = lookbackSeconds;

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
  prices[i] =getPriceFromTick(averageTick);
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

//Create a Quoter instance
IQuoter public constant quoter = IQuoter(0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6); 

// Get a quote for the amount of token out you would receive for a given amount of token in
function getAmountOut(uint256 amountIn, address tokenIn, address tokenOut, uint24 fee) public  returns (uint256 _amountOut) {
uint  amountOut = quoter.quoteExactInputSingle(tokenIn, tokenOut, fee, amountIn, 0); // Specify minimum amount out (0 for any amount)
return amountOut;
}

// Get a quote for the amount of token in you would need to swap to get a desired amount of token out
function getAmountIn(uint256 amountOut, address tokenIn, address tokenOut, uint24 fee) public  returns (uint256 amountIn) {
  amountIn = quoter.quoteExactOutputSingle(tokenIn, tokenOut, fee, amountOut, 0); // Specify maximum amount in (0 for any amount)
}



    // Constants
    int24 internal constant MIN_TICK = -887272;
    int24 internal constant MAX_TICK = -MIN_TICK;

// Function to calculate sqrtPrice from tick
    function getSqrtPriceX96FromTick(int24 tick) public pure returns (uint160 sqrtPriceX96) {
        require(tick >= MIN_TICK && tick <= MAX_TICK, "Tick out of bounds");

        // sqrtPriceX96 is a Q96.96 fixed-point number
        sqrtPriceX96 = uint160(1 << 96);
        if (tick > 0) {
            for (int24 i = 0; i < tick; i++) {
                sqrtPriceX96 = (sqrtPriceX96 * 10000) / 9999;
            }
        } else if (tick < 0) {
            for (int24 i = 0; i > tick; i--) {
                sqrtPriceX96 = (sqrtPriceX96 * 9999) / 10000;
            }
        }
    }

    // Function to calculate price from tick
    function getPriceFromTick(int24 tick) public pure returns (uint256 price) {
        uint160 sqrtPriceX96 = getSqrtPriceX96FromTick(tick);
        uint256 sqrtPrice = uint256(sqrtPriceX96) * uint256(sqrtPriceX96);
        // sqrtPriceX96 is a Q96.96 number, so we need to divide by 2^192 to get the actual price
        price = sqrtPrice / (1 << 192);
    }

}
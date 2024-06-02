// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library UniswapV3TickPriceConverter {
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

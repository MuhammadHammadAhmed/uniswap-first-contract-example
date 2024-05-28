// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/IQuoter.sol';

contract SimpleSwap {
    ISwapRouter public immutable swapRouter;
    IQuoter public immutable quoter;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint24 public constant feeTier = 3000;

    constructor(ISwapRouter _swapRouter,IQuoter _quoter) {
        swapRouter = _swapRouter;
        quoter=_quoter;
    }

    function swapWETHForDAI(uint256 amountIn) external returns (uint256 amountOut) {

        // Transfer the specified amount of WETH9 to this contract.
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);
        // Approve the router to spend WETH9.
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);
        // Note: To use this example, you should explicitly set slippage limits, omitting for simplicity
        uint256 minOut = /* Calculate min output */ 0;
        uint160 priceLimit = /* Calculate price limit */ 0;
        // Create the params that will be used to execute the swap
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: WETH9,
                tokenOut: DAI,
                fee: feeTier,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: minOut,
                sqrtPriceLimitX96: priceLimit
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }


/* Quote*/
  function quoteETHForDAI(uint256 amountIn) external returns (uint256 amountOut) {


address tokenIn=WETH9;
address tokenOut=DAI;
        uint256 minOut = /* Calculate min output */ 0;
                uint24 fee = /* Calculate min output */ 0;

        uint160 priceLimit = /*1443920880919018475403895602 Calculate price limit */ 0;


        // Transfer the specified amount of WETH9 to this contract.
      //  TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);
        // Approve the router to spend WETH9.
       // TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);

        // Note: To use this example, you should explicitly set slippage limits, omitting for simplicity
        // Create the params that will be used to execute the swap
        // ISwapRouter.ExactInputSingleParams memory params =
        //     ISwapRouter.ExactInputSingleParams({
        //         tokenIn: WETH9,
        //         tokenOut: DAI,
        //         fee: feeTier,
        //         recipient: msg.sender,
        //         deadline: block.timestamp,
        //         amountIn: amountIn,
        //         amountOutMinimum: minOut,
        //         sqrtPriceLimitX96: priceLimit
        //     });
        // The call to `exactInputSingle` executes the swap.
       // amountOut = swapRouter.exactInputSingle(params);

       uint amountOut=quoter.quoteExactInputSingle(
   WETH9,
   tokenOut,
   fee, 
   amountIn,
   priceLimit
 );
    }
}
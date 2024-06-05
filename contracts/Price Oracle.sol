// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.8.0;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PriceOracle {
  
    // address public pool;
    // uint32 public observationPeriod; // e.g., 3600 for 1 hour

    constructor(address _factory) {
     

    }

    function getPrice(uint128 amountIn,uint8 token, address _pool, uint32 _observationPeriod) external view returns (uint256) {
      IUniswapV3Pool  pool=IUniswapV3Pool(_pool);
       IERC20 token0=IERC20(pool.token0());
       IERC20  token1=IERC20(pool.token1());

        (int24 tick, ) = OracleLibrary.consult(_pool, _observationPeriod);
        uint256 price =(token==0)?OracleLibrary.getQuoteAtTick(tick, amountIn, pool.token0(), IUniswapV3Pool(_pool).token1()): OracleLibrary.getQuoteAtTick(tick, amountIn, pool.token1(), IUniswapV3Pool(_pool).token0());
        return price;
    }
}

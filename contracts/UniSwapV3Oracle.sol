// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.8.0;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";

contract UniswapV3Oracle {
    address public factory;
    address public pool;
    uint32 public observationPeriod; // e.g., 3600 for 1 hour

    constructor(address _factory, address _pool, uint32 _observationPeriod) {
        factory = _factory;
        pool = _pool;
        observationPeriod = _observationPeriod;
    }

    function getPrice() external view returns (uint256) {
        (int24 tick, ) = OracleLibrary.consult(pool, observationPeriod);
        uint256 price = OracleLibrary.getQuoteAtTick(tick, 1 ether, IUniswapV3Pool(pool).token1(), IUniswapV3Pool(pool).token0());
        return price;
    }
}

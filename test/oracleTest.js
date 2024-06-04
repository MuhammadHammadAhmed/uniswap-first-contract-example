const { expect } = require("chai");
const { ethers } = require("hardhat");

const YOUR_UNISWAP_FACTORY_ADDRESS="0x1F98431c8aD98523631AE4a59f267346ea31F984";
const USDC_WETH='0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8';
const USDC_USDT='0x3416cf6c708da44db2624d63ea0aaef7113527c6';

describe("ORACLE", function(){
    it("Should deploy a TOracle contract", async function () {
        const observationPeriod = 1; // 1 hour
        /* Deploy the Oracle contract */
        const OracleFActory = await hre.ethers.getContractFactory("UniswapV3Oracle");
                const oracleContract = await OracleFActory.deploy(YOUR_UNISWAP_FACTORY_ADDRESS, USDC_WETH, observationPeriod);
                await oracleContract.deployed();
        const response= await oracleContract.getPrice();
        console.log("Oracle response",response);
        

    });
});




const { expect } = require("chai");
const { ethers } = require("hardhat");

const YOUR_UNISWAP_FACTORY_ADDRESS="0x1F98431c8aD98523631AE4a59f267346ea31F984";
const USDC_WETH='0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8';
const USDC_USDT='0x3416cf6c708da44db2624d63ea0aaef7113527c6';

describe("Price ORACLE", function(){
    it("Should deploy a Oracle contract", async function () {
        const observationPeriod = 604800; // 1 hour
       const amountIn1=hre.ethers.utils.parseEther('1.0');
        const amountIn=ethers.utils.parseUnits('1.0',6);
        console.log("Units",amountIn1, amountIn);
        /* Deploy the Oracle contract */
        const OracleFActory = await hre.ethers.getContractFactory("PriceOracle");
                const oracleContract = await OracleFActory.deploy(YOUR_UNISWAP_FACTORY_ADDRESS);
                await oracleContract.deployed();
        const response= await oracleContract.getUniswapPrice(amountIn,0,USDC_WETH, observationPeriod);
        console.log("PriceOracle response",response);
        

    });
});




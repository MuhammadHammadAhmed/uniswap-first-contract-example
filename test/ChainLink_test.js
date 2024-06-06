const { expect } = require("chai");
const { ethers } = require("hardhat");

const YOUR_UNISWAP_FACTORY_ADDRESS="0x1F98431c8aD98523631AE4a59f267346ea31F984";
const USDC_WETH='0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8';
const USDC_USDT='0x3416cf6c708da44db2624d63ea0aaef7113527c6';
// chainlink
const XAG_USD="0x379589227b15F1a12195D3f2d90bBc9F31f95235";// silver
const XAU_USD="0x214eD9Da11D2fbe465a6fc601a91E62EbEc1a0D6";//gold


describe("ChainLink ORACLE", function(){
    it("Should deploy a Chain LinkOracle contract", async function () {
        
        const observationPeriod = 604800; // 1 hour
       const amountIn1=hre.ethers. utils.parseEther('1.0');
        const amountIn=ethers.utils.parseUnits('1.0',6);
        console.log("Units",amountIn1, amountIn);
        /* Deploy the Oracle contract */
        const OracleFActory = await hre.ethers.getContractFactory("PriceOracle");
                const oracleContract = await OracleFActory.deploy(YOUR_UNISWAP_FACTORY_ADDRESS);
                await oracleContract.deployed();
                console.log("before the call");
        const response= await oracleContract.getChainlinkData(XAU_USD);
      //  const xau=ethers.utils.parseUnits(response.value,8);
        console.log("ChainLink Oracle response:",parseFloat(response)/10**8);
        

    });
});




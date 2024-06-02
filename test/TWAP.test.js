const { expect } = require("chai");
const { ethers } = require("hardhat");
const USDC_WETH='0x54f1acac26b10cdffc8a43904713aa0ad67a33f9';
const USDC_USDT='0x3416cf6c708da44db2624d63ea0aaef7113527c6';
//-- wuoter
const WETH = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'; // weth
const USDC = '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48';
const tokenIn =WETH;
const fee=3000;
const amountIn=hre.ethers.utils.parseEther('1');
  const tokenOut = USDC;
let sqrtPriceLimitX96='1443920880919018475403895602';
let  inp=1;

describe("TWAP", function(){
    it("Should deploy a TWAP contract", async function () {
        /* Deploy the helloWorld contract */
        const TWAPFactory = await ethers.getContractFactory("TWAP");
        const TWAPContract = await TWAPFactory.deploy();
        await TWAPContract.deployed();
       const response= await TWAPContract.getTwap(5,USDC_WETH);
       console.log("TWAP",response);
        

    });
    // it("Should call a quoter", async function () {
    //     /* Deploy the helloWorld contract */
    //     const TWAPFactory = await ethers.getContractFactory("TWAP");
    //     const TWAPContract = await TWAPFactory.deploy();
    //     await TWAPContract.deployed();
    //    const response= await TWAPContract.getAmountOut(amountIn,tokenIn,tokenOut,fee);
    //    console.log("Quoter",response);
        

    // });
});
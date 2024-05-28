const { expect } = require("chai");
const { ethers } = require("hardhat");
const USDC_WETH='0x54f1acac26b10cdffc8a43904713aa0ad67a33f9';
const USDC_USDT='0x3416cf6c708da44db2624d63ea0aaef7113527c6';

describe("TWAP", function(){
    it("Should deploy a TWAP contract", async function () {
        /* Deploy the helloWorld contract */
        const TWAPFactory = await ethers.getContractFactory("TWAP");
        const TWAPContract = await TWAPFactory.deploy();
        await TWAPContract.deployed();
        const response= await TWAPContract.getTwap(5,USDC_WETH);
        console.log("TWAP",response);
        

    });
});
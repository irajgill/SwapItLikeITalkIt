import { BigNumber, ethers } from "ethers";
import {contract , tokenContract} from "./contract";
import { toEther, toWei } from "./utils";

export async function swapEthToToken(tokenName , amount){
    try{
        let tx = {value: toWei(amount)};

        const  contractObj = await contract();
        const data = contractObj.swapEthToToken(tokenName, tx);
        console.log(data);
    }catch(e){
        console.log(e);
    }
}   

export async function hasValidAllownace(tokenName , owner , amount){
    try{
        const contractObj = await contract();
       const address = await contractObj.getTokenAddress(tokenName);
       const tokenContractObj = await tokenContract(address);
       const data = await tokenContractObj.allowance(owner, "0x8C3dfF46acDc96987983bc723B7f2cAAF0653EF4" )//public address);
       console.log(data);
       const result = BigNumber.from(data.toStrin()).gte(BigNumber.from(toWei(amount)));
       return result;
       console.log(result);
    }catch(e){
        console.log(e);
    }
}

export async function swapTokenToEth(tokenName , amount){
   try{
    const contractObj = await contract();
    const data = await contractObj.swapTokenToEth(tokenName, toWei(amount));

    const receipt = await data.wait();
    console.log(receipt);
    return receipt;
   }catch(e){
    console.log(e);
   }
   }


   export async function swapTokenToToken(srcToken , destToken , amount){
    try{
        const contractObj = await contract();
        const data = await contractObj.swapTokenToToken(srcToken, destToken, toWei(amount));
        const receipt = await data.wait();
        console.log(receipt);
        return receipt;
    }catch(e){
        console.log(e);
    }
   }


   export async function getTokenBalance(tokenName , address){
    const contractObj = await contract();
    const balance = await contractObj.getTokenBalance(tokenName, address);
    return balance;

   }

   export async function getTokenAddress(tokenName){
    const contractObj = await contract();
    const address = await contractObj.getTokenAddress(tokenName);
    return address;
   }

   export async function increaseAllowance(tokenName , amount){
    const contractObj = await contract();
    const address = await contractObj.getTokenAddress(tokenName);
    const tokenContractObj = await tokenContract(address);
    const data = await tokenContractObj.increaseAllowance("0x8C3dfF46acDc96987983bc723B7f2cAAF0653EF4", toWei(amount));
    const receipt = await data.wait();
    console.log(receipt);
    return receipt;
   }

   export async function getAllHistory(){
    try{
        const contractObj = await contract();
        const getAllHistory = await contractObj.getAllHistory();

        const historyTransaction = getAllHistory.map((history, i) => ({
            historyId : history.historyId.toNumber(),
            tokenA : history.tokenA,
            tokenB : history.tokenB,
            inputValue: toEther(history?.inputValue),
            outputValue: toEther(history?.outputValue),
            userAddress: history.userAddress,

        }))
        return historyTransaction;
    }catch(e){
        console.log(e);
    }
    
    
   }


   
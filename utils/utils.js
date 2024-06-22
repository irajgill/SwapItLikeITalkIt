import {ethers} from 'ethers';

export function toWei(amount, decimal = 18){
    const toWei  = ethers.utils.parseUnits(amount, decimal);
    return toWei.toString();
}

export function toEther(amount, decimal = 18){
    const toEther = ethers.utils.formatUnits(amount, decimal);
    return toEther.toString();
}
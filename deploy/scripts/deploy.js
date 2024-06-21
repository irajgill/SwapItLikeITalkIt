const hre = require("hardhat");

async function main() {
    const CustomDex = await hre.ethers.getContractFactory("CustomDex");
    const customDex = await CustomDex.deploy();

    await customDex.deployed();

    console.log("CustomDex deployed to:", customDex.address);
}


main()
    .catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });


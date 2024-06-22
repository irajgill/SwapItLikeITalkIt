require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */


const NEXT_PUBLIC_PRIVATE_KEY = "";
module.exports = {
  solidity: "0.8.0",
  defaultNetwork: "matic",
  networks: {
    hardhat: {},
    polygon_mumbai: {
      url: 'https://eth-sepolia.g.alchemy.com/v2/HjwQ1LphiIbwUgdsDyMeN8e7HnN9bZ6B',
      accounts: [`0x${NEXT_PUBLIC_PRIVATE_KEY}`],
    },
  },
};


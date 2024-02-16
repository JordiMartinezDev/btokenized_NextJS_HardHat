require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: { chainId: 1337 },
    mumbai: {
      url: process.env.POLYGON_MUMBAI_URL,
      accounts: [process.env.WALLET_SECRET],
    },
    mainnet: {
      url: process.env.POLYGON_MAINNET_URL,
      accounts: [process.env.WALLET_SECRET],
    },
  },
  solidity: "0.8.24",
};

require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "bitfinity-testnet",
  solidity: "0.8.4",
  networks: {
    "bitfinity-testnet": {
      chainId: 355113,
      url: "https://testnet.bitfinity.network",
      accounts: { mnemonic: process.env.MNEMONIC || "" },
    },
    bitfinity: {
      chainId: 355110,
      url: "https://mainnet.bitfinity.network",
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      "bitfinity-testnet": "0x",
      bitfinity: "0x",
    },
    customChains: [
      {
        network: "bitfinity-testnet",
        chainId: 355113,
        urls: {
          apiURL: "https://explorer.testnet.bitfinity.network/api",
          browserURL: "https://explorer.testnet.bitfinity.network/",
        },
      },
      {
        network: "bitfinity",
        chainId: 355110,
        urls: {
          apiURL: "https://explorer.mainnet.bitfinity.network/api",
          browserURL: "https://explorer.mainnet.bitfinity.network/",
        },
      },
    ],
  },
  sourcify: {
    enabled: false,
  },
};

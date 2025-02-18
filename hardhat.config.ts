import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-contract-sizer";
import "@nomiclabs/hardhat-etherscan";

dotenv.config();

const DEFAULT_OPTIMIZER = {
  version: "0.8.17",
  settings: {
    optimizer: {
      enabled: true,
      runs: 1000000
    },
  },
}

const PRODUCT_OPTIMIZER = {
  version: "0.8.17",
  settings: {
    optimizer: {
      enabled: true,
      runs: 300
    },
  },
}



const config: HardhatUserConfig = {
  mocha: {
    timeout: 100000000
  },
  solidity: {
    compilers: [DEFAULT_OPTIMIZER],
    overrides: {
      "contracts/Product.sol": PRODUCT_OPTIMIZER,
      "contracts/CPPIProduct.sol": PRODUCT_OPTIMIZER,
      "contracts/archive/customErrorProduct.sol": PRODUCT_OPTIMIZER
    },
  },
  networks: {
    hardhat: {
      accounts: {
        count: 20,
        mnemonic: "test test test test test test test test test test test junk",
      },
      // chainId: 1337,
      chainId: 137, // MATIC FORK
      forking: {
        url: process.env.ALCHEMY_MATIC_URL || "https://polygon-rpc.com/",
        blockNumber: Number(process.env.POLYGON_BLOCK_NUMBER),
      },
      loggingEnabled: false,
    },
    matic: {
      url: process.env.MATIC_URL || "https://polygon-rpc.com/",
      accounts: [process.env.TEST_ACC1 || "", process.env.TEST_ACC2 || ""]
    },
    mumbai : {
      url: "https://rpc-mumbai.maticvigil.com/",
      accounts: [process.env.TEST_ACC1 || "" , process.env.TEST_ACC2 || ""]
    },
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  typechain: {
    alwaysGenerateOverloads: true,
  },
};

export default config;

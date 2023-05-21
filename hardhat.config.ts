require("@nomiclabs/hardhat-ethers");

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.1",
  defaultNetwork: "goerli",
  networks: {
    hardhat: {},
    goerli: {
      url: "https://goerli.infura.io/v3/__PROJECT_ID__",
      accounts: [`__ACCOUNT_PRIVATE_KEY__`],
    },
  },
};

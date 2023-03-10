require("dotenv").config();
// require("@nomiclabs/hardhat-waffle");

require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai:{
      url:process.env.MUMBAI_RPC_TESTNET_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
},
etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  },
};

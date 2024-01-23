require("@nomicfoundation/hardhat-verify");
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config();


const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL;
const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
		compilers: [
			{
				version: '0.8.20',
				settings: {
					optimizer: {
						enabled: true,
						runs: 200,
					},
				},
			},
		],
	},
	networks: {
		hardhat: {
		  chainId: 31337,
		},
		localhost: {
		  chainId: 31337,
		},
		sepolia: {
		  url: SEPOLIA_RPC_URL,
		  accounts: [PRIVATE_KEY],
		  chainId: 11155111,
		  blockConfirmations: 6,
		},
		goerli: {
		  url: GOERLI_RPC_URL,
		  accounts: [PRIVATE_KEY],
		  chainId: 5,
		  blockConfirmations: 6,
		},
	  },
	  etherscan: {
		apiKey: ETHERSCAN_API_KEY,
	  },
};

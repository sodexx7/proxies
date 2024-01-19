require("@nomicfoundation/hardhat-verify");
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config();

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
		// sepolia: {
		//   url: SEPOLIA_RPC_URL,
		//   accounts: [PRIVATE_KEY],
		//   chainId: 11155111,
		//   blockConfirmations: 6,
		// },
		// goerli: {
		//   url: GOERLI_RPC_URL,
		//   accounts: [PRIVATE_KEY],
		//   chainId: 5,
		//   blockConfirmations: 6,
		// },
	  },
};

const PNFT = artifacts.require("./PNFTToken");
const PaiSwap = artifacts.require("./PAISwap");

const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');

module.exports = async (deployer, network) => {

  const accounts = await web3.eth.getAccounts();
  let sender = accounts[0];
  console.log('Attempting to deploy from account', sender);

  //1. deploy Token contract
  var pai;

  if (network == 'testnet') {
    pai = await deployer.deploy(PNFT, "ETH PAI Token", "PAI", { from: sender });

    const amount = "20000000000000000000000000000";
    await pai.mint(sender, amount, { from: sender });
  }

  if (network == 'mainnet') {
    pai = "0xB9bb08AB7E9Fa0A1356bd4A39eC0ca267E03b0b3";
  }

  let pNft = await deployer.deploy(PNFT, "Pizzap Token", "PNFT", { from: sender });

  //2. deploy config contract
  let pMSwap = await deployer.deploy(PaiSwap,pai.address,pNft.address ,{ from: sender });

  // mint PNFT
  const amount = "20000000000000000000000000000";
  await pNft.mint(sender, amount, { from: sender });
};

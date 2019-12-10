const Token = artifacts.require("Token"); // Import contracts
const Exchange = artifacts.require("Exchange");

module.exports = async function(deployer) {
  const accounts = await web3.eth.getAccounts() // Gets the list of accounts on Ganache

  await deployer.deploy(Token); // Deploy token

  const feeAccount = accounts[0]
  const feePercent = 10

  await deployer.deploy(Exchange, feeAccount, feePercent) // pass in the constructor values for the exchange deployer
};

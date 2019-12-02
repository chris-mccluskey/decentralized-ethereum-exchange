const Token = artifacts.require("Token"); // Import contracts
const Exchange = artifacts.require("Exchange");

module.exports = async function(callback) { // This exports an asynchronos function, takes a callback function. Must call the callback when the script is finished. Run in console 'truffle exec scripts/seed-exchange.js'
  try {
    // Fetch accounts from wallet - these are unlocked
    const accounts = await web3.eth.getAccounts()

    // Fetched deployed Token
    const token = await Token.deployed()
    console.log("Token fetched", token.address)

    // Fetch deployed Exchange
    const exchange = await Exchange.deployed()
    console.log("Exchange fetched", exchange.address)
    

  } catch (error) { // Catch errors as a lot is happening and errors could be thrown.
    console.log(error)
  }

  callback()
}

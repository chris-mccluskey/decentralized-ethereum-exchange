// Interactions will contain interactions with the loadBlockchainData
import Web3 from 'web3'
import Token from '../abis/Token.json'
import Exchange from '../abis/Exchange.json'
import {
  web3Loaded,
  web3AccountLoaded,
  tokenLoaded,
  exchangeLoaded
} from './actions'



export const loadWeb3 = (dispatch) => {
  const web3 = new Web3(Web3.givenProvider || "HTTP://127.0.0.1:7545")
  dispatch(web3Loaded(web3))
  return web3
}

export const loadAccount = async (dispatch, web3) => {
  const accounts = await web3.eth.getAccounts()
  const account = accounts[0]
  dispatch(web3AccountLoaded(account))
  return account
}

export const loadToken = async (dispatch, web3, networkId) => {
  try {
    const token = new web3.eth.Contract(Token.abi, Token.networks[networkId].address)
    dispatch(tokenLoaded(token))
    return token
  } catch (error) {
    console.log('Contract not deployed to the current network. Please select another network with MetaMask')
    return null
  }
}

export const loadExchange = async (dispatch, web3, networkId) => {
  try {
    const exchange = new web3.eth.Contract(Exchange.abi, Exchange.networks[networkId].address)
    dispatch(exchangeLoaded(exchange))
    return exchange
  } catch (error) {
    console.log('Contract not deployed to the current network. Please select another network with MetaMask')
    return null
  }
}

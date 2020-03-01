// Interactions will contain interactions with the loadBlockchainData
import Web3 from 'web3'
import Token from '../abis/Token.json'
import Exchange from '../abis/Exchange.json'
import {
  web3Loaded,
  web3AccountLoaded,
  tokenLoaded,
  exchangeLoaded,
  cancelledOrdersLoaded,
  filledOrdersLoaded,
  allOrdersLoaded,
  orderCancelling,
  orderCancelled
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

export const loadAllOrders = async (dispatch, exchange) => {
  // Fetch cancelled orders with the "Cancel" stream
  const cancelStream = await exchange.getPastEvents('Cancel', { fromBlock: 0, toBlock: 'latest' })
  // Format cancelled orders
  const cancelledOrders = cancelStream.map((event) => event.returnValues)
  // Add cancelled orders to the Redux store
  dispatch(cancelledOrdersLoaded(cancelledOrders))
  // Fetch filled orders with the "Trade" event stream
  const tradeStream = await exchange.getPastEvents('Trade', { fromBlock: 0, toBlock: 'latest' })
  // Format filled orders
  const filledOrders = tradeStream.map((event) => event.returnValues)
  // Add filled orders to redux state
  dispatch(filledOrdersLoaded(filledOrders))
  // Fetch all orders with the "Order" event stream
  const orderStream = await exchange.getPastEvents('Order', { fromBlock: 0, toBlock: 'latest' })
  // Format all orders
  const allOrders = orderStream.map((event) => event.returnValues)
  // Add open orders to Redux store
  dispatch(allOrdersLoaded(allOrders))
}

export const cancelOrder = (dispatch, exchange, order, account) => {
  exchange.methods.cancelOrder(order.id).send({ from: account })
  .on('transactionHash', (hash) => {
    dispatch(orderCancelling())
  })
  .on('error', (error) => {
    console.log(error)
    window.alert('You need more gas bro!')
  })
}

export const subscribeToEvents = async (dispatch, exchange) => {
  exchange.events.Cancel({}, (error, event) => {
    dispatch(orderCancelled(event.returnValues))
  })
}

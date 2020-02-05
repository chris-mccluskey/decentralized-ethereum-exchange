import { get } from 'lodash' // lodash has a lot of helpful javascript functions
import { createSelector } from 'reselect'

const account = state => get(state, 'web3.account')
export const accountSelector = createSelector(account, a => a)

const tokenLoaded = state => get(state, 'token.loaded', false)
export const tokenLoadedSelector = createSelector(tokenLoaded, tl => tl)

const exchangeLoaded = state => get(state, 'exchange.loaded', false)
export const exchangeLoadedSelector = createSelector(exchangeLoaded, el => el)

const exchange = state => get(state, 'exchange.contract')
export const exchangeSelector = createSelector(exchange, e => e)

export const contractsLoadedSelector = createSelector(
  tokenLoaded,
  exchangeLoaded,
  (tl, el) => (tl && el)
)

const filledOrdersLoaded = state => get(state, 'exchange.filledOrders.loaded', false)
export const filledOrdersLoadedSelector = createSelector(filledOrdersLoaded, loaded => loaded)

const filledOrders = state => get(state, 'exchange.filledOrders.data', [])
export const filledOrdersSelector = createSelector(
  filledOrders,
  (orders) => {
    // Decorate orders
    orders = decoratefilledOrders(orders)

    // Sort orders by date descending for display
    orders = orders.sort((a, b) => b.timestamp - a.timestamp)
    console.log(orders)
  }
)

const decoratefilledOrders = (orders) => {
  return(
    orders.map((order) => {
      return order = decorateOrder(order)
    })
  )
}

const decorateOrder = (order) => {
  return order
}

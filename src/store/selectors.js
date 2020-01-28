import { get } from 'lodash' // lodash has a lot of helpful javascript functions
import { createSelector } from 'reselect'

const account = state => get(state, 'web3.account')
export const accountSelector = createSelector(account, a => a)

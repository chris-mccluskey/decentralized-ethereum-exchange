export const EVM_REVERT = 'VM Exception while processing transaction: revert'

export const ETHER_ADDRESS = '0x0000000000000000000000000000000000000000'

export const ether = (n) => { // ether into wei 
  return new web3.utils.BN(
  web3.utils.toWei(n.toString(), 'ether')
  )
}

// same as ether
export const tokens = (n) => ether(n)

// import React, { Component } from 'react'
// import './App.css';
// import Web3 from 'web3'
// import NavBar from './NavBar'
// import Content from './Content'
// import { connect } from 'react-redux'
// import {
//   loadWeb3,
//   loadAccount,
//   loadToken,
//   loadExchange
// } from '../store/interactions.js'
// import { contractsLoadedSelector } from '../store/selectors'
//
//
// // componentWillMount is a react life cycle function.
// class App extends Component {
//   componentWillMount() {
//     this.loadBlockchainData(this.props.dispatch)
//   }
//
//   // For web3.eth.Contract the first parameter is jsonInterface it will be the 'abi', that tells us all the behavoir, how token works, functions, arguements, properties of smart contract, all behavoir. Address is where it is on the blockchain. That is all contained in the ABI json file.
//   async loadBlockchainData(dispatch) {
//     const web3 = loadWeb3(dispatch)
//     await web3.eth.net.getNetworkType() // Returns the network type
//     const networkId = await web3.eth.net.getId() // Returns networkId
//     await loadAccount(dispatch, web3) // Returns the accounts connected.
//     const token = await loadToken(dispatch, web3, networkId)  // Access the Token contract on the chain.
//     if(!token) {
//       window.alert('Token smart contract not detected on the current network. Please select another network with Metamask.')
//       return
//     }
//     const exchange = await loadExchange(dispatch, web3, networkId)
//     if(!exchange) {
//       window.alert('Exchange smart contract not detected on the current network. Please select another network with Metamask.')
//       return
//     }
//
//
//     window.addEventListener("load", async () => {
//       // Modern dapp browsers...
//       if (window.ethereum) {
//         window.web3 = new Web3(window.ethereum);
//         try {
//           // Request account access if needed
//           await window.ethereum.enable();
//         } catch (error) {
//           // User denied account access...
//         }
//       }
//       // Legacy dapp browsers...
//       else if (window.web3) {
//         window.web3 = new Web3(web3.currentProvider);
//       }
//       // Non-dapp browsers...
//       else {
//         console.log("Non-Ethereum browser detected. You should consider trying MetaMask");
//       }
//     });
//   }
// // Must use className when working with react rather than just the default class
//   render() {
//
//     return (
//       <div>
//         < NavBar />
//         { this.props.contractsLoaded ? < Content /> : <div className="content"></div> }
//       </div>
//     );
//   }
// }
//
// function mapStateToProps(state) {
//   return {
//     contractsLoaded: contractsLoadedSelector(state)
//   }
// }
//
// export default connect(mapStateToProps)(App);

import React, { Component } from 'react'
import './App.css'
import Navbar from './NavBar'
import Content from './Content'
import { connect } from 'react-redux'
import {
  loadWeb3,
  loadAccount,
  loadToken,
  loadExchange
} from '../store/interactions'
import { contractsLoadedSelector } from '../store/selectors'

class App extends Component {
  componentWillMount() {
    this.loadBlockchainData(this.props.dispatch)
  }

  async loadBlockchainData(dispatch) {
    const web3 = loadWeb3(dispatch)
    await web3.eth.net.getNetworkType()
    const networkId = await web3.eth.net.getId()
    await loadAccount(dispatch, web3)
    const token = await loadToken(dispatch, web3, networkId)
    if(!token) {
      window.alert('Token smart contract not detected on the current network. Please select another network with Metamask.')
      return
    }
    const exchange = await loadExchange(dispatch, web3, networkId)
    if(!exchange) {
      window.alert('Exchange smart contract not detected on the current network. Please select another network with Metamask.')
      return
    }
  }

  render() {
    return (
      <div>
        <Navbar />
        { this.props.contractsLoaded ? <Content /> : <div className="content"></div> }
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    contractsLoaded: contractsLoadedSelector(state)
  }
}

export default connect(mapStateToProps)(App)

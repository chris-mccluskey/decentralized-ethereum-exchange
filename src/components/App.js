import React, { Component } from 'react'
import './App.css';
import Web3 from 'web3'
import NavBar from './NavBar'
import { connect } from 'react-redux'
import {
  loadWeb3,
  loadAccount,
  loadToken,
  loadExchange
} from '../store/interactions.js'


// componentWillMount is a react life cycle function.
class App extends Component {
  componentWillMount() {
    this.loadBlockchainData(this.props.dispatch)
  }

  // For web3.eth.Contract the first parameter is jsonInterface it will be the 'abi', that tells us all the behavoir, how token works, functions, arguements, properties of smart contract, all behavoir. Address is where it is on the blockchain. That is all contained in the ABI json file.
  async loadBlockchainData(dispatch) {
    const web3 = loadWeb3(dispatch)
    const network = await web3.eth.net.getNetworkType() // Returns the network type
    const networkId = await web3.eth.net.getId() // Returns networkId
    const accounts = await loadAccount(dispatch, web3) // Returns the accounts connected.
    const token = new loadToken(dispatch, web3, networkId) // Access the Token contract on the chain.
    loadExchange(dispatch, web3, networkId)


    window.addEventListener("load", async () => {
      // Modern dapp browsers...
      if (window.ethereum) {
        window.web3 = new Web3(window.ethereum);
        try {
          // Request account access if needed
          await window.ethereum.enable();
        } catch (error) {
          // User denied account access...
        }
      }
      // Legacy dapp browsers...
      else if (window.web3) {
        window.web3 = new Web3(web3.currentProvider);
      }
      // Non-dapp browsers...
      else {
        console.log("Non-Ethereum browser detected. You should consider trying MetaMask");
      }
    });
  }
// Must use className when working with react rather than just the default class
  render() {

    return (
      <div>
        < NavBar />
        <div className="content">
          <div className="vertical-split">
            <div className="card bg-dark text-white">
              <div className="card-header">
                Card Title
              </div>
              <div className="card-body">
                <p className="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                <a href="/#" className="card-link">Card link</a>
              </div>
            </div>
            <div className="card bg-dark text-white">
              <div className="card-header">
                Card Title
              </div>
              <div className="card-body">
                <p className="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                <a href="/#" className="card-link">Card link</a>
              </div>
            </div>
          </div>
          <div className="vertical">
            <div className="card bg-dark text-white">
              <div className="card-header">
                Card Title
              </div>
              <div className="card-body">
                <p className="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                <a href="/#" className="card-link">Card link</a>
              </div>
            </div>
          </div>
          <div className="vertical-split">
            <div className="card bg-dark text-white">
              <div className="card-header">
                Card Title
              </div>
              <div className="card-body">
                <p className="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                <a href="/#" className="card-link">Card link</a>
              </div>
            </div>
            <div className="card bg-dark text-white">
              <div className="card-header">
                Card Title
              </div>
              <div className="card-body">
                <p className="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                <a href="/#" className="card-link">Card link</a>
              </div>
            </div>
          </div>
          <div className="vertical">
            <div className="card bg-dark text-white">
              <div className="card-header">
                Card Title
              </div>
              <div className="card-body">
                <p className="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                <a href="/#" className="card-link">Card link</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    // Soon
  }
}

export default connect(mapStateToProps)(App);

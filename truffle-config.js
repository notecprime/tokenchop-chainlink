const HDWalletProvider = require('@truffle/hdwallet-provider')
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();
const path = require("path");

module.exports = {
  networks: {
    cldev: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
      gas: 160928184,
      disableConfirmationListener: true
    },
    kovan: {
      provider: () => {
        return new HDWalletProvider(mnemonic, 'https://kovan.infura.io/v3/745cd1833a614b1baccb123b6f9551f5')
      },
      network_id: '42',
      skipDryRun: true
    },
    rinkeby: {
      provider: () => {
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/745cd1833a614b1baccb123b6f9551f5')
      },
      network_id: '4',
      skipDryRun: true
    },    
  },
  compilers: {
    solc: {
      version: '0.6.12',
    },
  },
}

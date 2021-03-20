const readFileSync = require('fs').readFileSync;
const execSync = require('child_process').execSync;

const mem = readFileSync('.secret', {encoding: 'utf8'});

execSync(`ganache-cli -m \"${mem}\" --gasLimit 0x99791b8 --allowUnlimitedContractSize -f https://rinkeby.infura.io/v3/745cd1833a614b1baccb123b6f9551f5`, {stdio: 'inherit'})
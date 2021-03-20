const readFileSync = require('fs').readFileSync;
const execSync = require('child_process').execSync;

const mem = readFileSync('.secret', {encoding: 'utf8'});

execSync(`ganache-cli -m \"${mem}\" --gasLimit 0x99791b8 --allowUnlimitedContractSize -f http://127.0.0.1:7545`, {stdio: 'inherit'})
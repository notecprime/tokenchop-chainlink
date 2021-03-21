const MyContract = artifacts.require('MyContract')
const { LinkToken } = require('@chainlink/contracts/truffle/v0.4/LinkToken')
const { Oracle } = require('@chainlink/contracts/truffle/v0.6/Oracle')

module.exports = async (deployer, network, [defaultAccount]) => {
  LinkToken.setProvider(deployer.provider)
  Oracle.setProvider(deployer.provider)
  try {
    await deployer.deploy(LinkToken, { from: defaultAccount })
    await deployer.deploy(Oracle, LinkToken.address, { from: defaultAccount })
    await deployer.deploy(MyContract, LinkToken.address)
  } catch (err) {
    console.error(err)
  }
}

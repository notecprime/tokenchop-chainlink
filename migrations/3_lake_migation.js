const SpecLake = artifacts.require('SpecLake')
const StableLake = artifacts.require('StableLake')

module.exports = async (deployer, network, [defaultAccount]) => {
    try {
        await deployer.deploy(SpecLake, '0x8A753747A1Fa494EC906cE90E9f37563A8AF630e')
        await deployer.deploy(StableLake, '0x8A753747A1Fa494EC906cE90E9f37563A8AF630e')
        const spec = await SpecLake.deployed();
        await spec.setSister(StableLake.address, { from: defaultAccount });
        const stable = await StableLake.deployed();
        await stable.setSister(SpecLake.address, { from: defaultAccount });      
    } catch (err) {
        console.error(err)
    }
}

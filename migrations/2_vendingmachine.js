const PropertyNames = artifacts.require("./PropertyNames.sol");
const PropertyGenerator = artifacts.require("./PropertyGenerator.sol");
const VendingObject = artifacts.require('./VendingObject.sol');
const VendingMachine = artifacts.require('./VendingMachine.sol');
const MetaData = artifacts.require('./MetaData.sol');

module.exports = async function(deployer, network, accounts) {

  await deployer.deploy(PropertyNames);
  await deployer.deploy(PropertyGenerator);
  await deployer.deploy(MetaData, "http://test.barkingmad.io/");
  let propertyNamesInstance = await PropertyNames.deployed();
  let propertyGeneratorInstance = await PropertyGenerator.deployed();
  let metaDataInstance = await MetaData.deployed();
  await deployer.deploy(VendingObject, 
                        metaDataInstance.address, 
                        propertyNamesInstance.address,  
                        propertyGeneratorInstance.address);
  let vendingObjectInstance = await VendingObject.deployed();
  await deployer.deploy(VendingMachine, vendingObjectInstance.address);

  console.log(VendingMachine.deployed().address);
}
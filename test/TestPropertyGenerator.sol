pragma solidity >=0.4.25 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PropertyGenerator.sol";

contract TestPropertyGenerator {

  function testValidProperty() public {

    PropertyGenerator propertyGenerator = PropertyGenerator(DeployedAddresses.PropertyGenerator());
    Assert.equal(propertyGenerator.generate(0), 0, "Invalid property id must return 0");
    Assert.equal(propertyGenerator.generate(1), 1, "Other properties at the moment must return 1");
  }
}
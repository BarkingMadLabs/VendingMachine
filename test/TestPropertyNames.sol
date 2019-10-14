pragma solidity >=0.4.25 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PropertyNames.sol";

contract TestPropertyNames {

  function testValidPropertyNames() public {

    PropertyNames names = PropertyNames(DeployedAddresses.PropertyNames());
    (uint256[] memory ids, bytes16[] memory n) = names.propertyNames();
    Assert.equal(ids.length, 4, "Invalid length of id array");
    Assert.equal(n.length, 4, "Invalid length of name array");

    Assert.equal(ids[0], 1, "Invalid property value for field 0");
    Assert.equal(ids[1], 2, "Invalid property value for field 1");
    Assert.equal(ids[2], 3, "Invalid property value for field 2");
    Assert.equal(ids[3], 4, "Invalid property value for field 3");
  }
}
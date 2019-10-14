pragma solidity >=0.4.25 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/VendingObject.sol";
import "../contracts/PropertyNames.sol";
import "../contracts/PropertyGenerator.sol";

contract TestVendingObject {

  function testUri() public {

    VendingObject vendingObject = VendingObject(DeployedAddresses.VendingObject());

    string memory uri = vendingObject.tokenURI(1);
    AssertString.isNotEmpty(uri, "uri should be returned");
  }

  function testMint() public {

    VendingObject vendingObject = VendingObject(DeployedAddresses.VendingObject());

    uint256 tokenId = vendingObject.mint((address)(this));

    AssertUint.isAbove(tokenId, 0, "Invalid token id");
  }
}
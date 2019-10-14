pragma solidity ^0.5.0;
import '@openzeppelin/contracts/ownership/Ownable.sol';
import './IVendingObjectCreator.sol';

contract VendingMachine is Ownable {

    IVendingObjectCreator public vendingObjectCreator;

    constructor(IVendingObjectCreator _vendingObjectCreator)
        public {

        // TODO - check the validity of these interfaces
        vendingObjectCreator = _vendingObjectCreator;
    }

    function mint()
        public
        payable
        returns(uint256 tokenId) {

        // check payment
        require(msg.value > 0.001 ether, 'Send more next time');
        require(msg.sender != address(0x0), 'Invalid address');

        return vendingObjectCreator.mint(msg.sender);
    }

    function setVendingObject(IVendingObjectCreator _vendingObjectCreator)
        public
        onlyOwner {
        vendingObjectCreator = _vendingObjectCreator;
    }
}
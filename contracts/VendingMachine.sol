pragma solidity ^0.5.0;
import '@openzeppelin/contracts/ownership/Ownable.sol';
import './IVendingObjectCreator.sol';

contract VendingMachine is Ownable {

    IVendingObjectCreator public vendingObjectCreator;

    event VendingObjectCreated(address indexed to, uint256 indexed tokenId);

    constructor(IVendingObjectCreator _vendingObjectCreator)
        public {

        // TODO - check the validity of these interfaces
        vendingObjectCreator = _vendingObjectCreator;
    }

    function mint()
        public
        payable
        returns(uint256 _tokenId) {

        // check payment
        require(msg.value > 0.001 ether, 'Send more next time');
        require(msg.sender != address(0x0), 'Invalid address');

        _tokenId = vendingObjectCreator.mint(msg.sender);

        emit VendingObjectCreated(msg.sender, _tokenId);

        return _tokenId;
    }

    function setVendingObject(IVendingObjectCreator _vendingObjectCreator)
        public
        onlyOwner {
        vendingObjectCreator = _vendingObjectCreator;
    }
}
pragma solidity ^0.5.0;
import '@openzeppelin/contracts/access/roles/WhitelistAdminRole.sol';
import '@openzeppelin/contracts/payment/PullPayment.sol';
import './IVendingObjectCreator.sol';
import '@openzeppelin/contracts/payment/PaymentSplitter.sol';

contract VendingMachine is WhitelistAdminRole, PullPayment, PaymentSplitter {

    using SafeMath for uint256;

    IVendingObjectCreator public vendingObjectCreator;

    event VendingObjectCreated(address indexed to, uint256 indexed tokenId, uint256 priceInWei);
    event PriceChanged(address indexed sender, uint256 indexed oldPrice, uint256 indexed newPrice);
    event VendingObjectCreatorChanged(address indexed sender, address indexed oldAddress, address indexed newAddress);

    uint256 public price;

    constructor(address[] memory payees, uint256[] memory shares, IVendingObjectCreator _vendingObjectCreator, uint256 _price)
        PaymentSplitter(payees, shares)
        public
        payable {

        price = _price;
        // TODO - check the validity of these interfaces
        vendingObjectCreator = _vendingObjectCreator;
    }

    function mint()
        public
        payable
        returns(uint256 _tokenId) {

        // check payment
        require(msg.value >= price, 'Send more next time');
        require(msg.sender != address(0x0), 'Invalid address');

        _tokenId = vendingObjectCreator.mint(msg.sender);

        emit VendingObjectCreated(msg.sender, _tokenId, price);

        uint256 credit = msg.value.sub(price);
        if (credit > 0)
            _asyncTransfer(msg.sender, credit);

        return _tokenId;
    }

    function setVendingObject(IVendingObjectCreator _vendingObjectCreator)
        public
        onlyWhitelistAdmin {

        emit VendingObjectCreatorChanged(msg.sender, address(vendingObjectCreator), address(_vendingObjectCreator));

        vendingObjectCreator = _vendingObjectCreator;
    }

    function setPrice(uint256 _price)
        public
        onlyWhitelistAdmin {

        emit PriceChanged(msg.sender, price, _price);

        price = _price;
    }
}
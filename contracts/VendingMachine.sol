pragma solidity ^0.5.0;
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './IPropertyGenerator.sol';

contract VendingMachine is Ownable {

    struct VendingObject {
        mapping(bytes16 => uint256) properties;
    }

    IPropertyGenerator public propertyGenerator;

    constructor(IPropertyGenerator _propertyGenerator) public {
        propertyGenerator = _propertyGenerator;
    }

    function mint() public onlyOwner {

    }
}
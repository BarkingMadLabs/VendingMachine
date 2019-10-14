pragma solidity ^0.5.0;
import '@openzeppelin/contracts/ownership/Ownable.sol';
import './IPropertyGenerator.sol';

contract PropertyGenerator is IPropertyGenerator, Ownable {

    constructor() public {
    }

    function generate(uint256 _propertyId)
        external
        returns (uint256 value) {

        if(_propertyId > 0)
            return 1;
        return 0;
    }
}
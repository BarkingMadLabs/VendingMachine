pragma solidity ^0.5.0;
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './IPropertyNames.sol';

contract PropertyNames is IPropertyNames, Ownable {

    constructor() public {
    }

    function propertyName(uint256 index)
    external
    view
    returns (bytes16 name) {
        require(index < 4, 'Out of bounds');

        if (index == 0)
            return "name";
        if (index == 1)
            return "age";
        if (index == 2)
            return "width";
        if (index == 3)
            return "height";

    }

}
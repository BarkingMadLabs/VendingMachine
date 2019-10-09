pragma solidity ^0.5.0;
import '@openzeppelin/contracts/ownership/Ownable.sol';
import './IPropertyNames.sol';

contract PropertyNames is IPropertyNames, Ownable {

    constructor() public {
    }

    function propertyNames()
        external
        view
        returns(bytes16[] memory names) {

        names[0] = "name";
        names[1] = "age";
        names[2] = "width";
        names[3] = "height";
    }

}
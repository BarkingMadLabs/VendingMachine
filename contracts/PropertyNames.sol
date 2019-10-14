pragma solidity ^0.5.0;
import '@openzeppelin/contracts/ownership/Ownable.sol';
import './IPropertyNames.sol';

contract PropertyNames is IPropertyNames, Ownable {

    constructor() public {
    }

    function propertyNames()
        external
        view
        returns(uint256[] memory ids, bytes16[] memory names) {

        ids = new uint256[](4);
        names = new bytes16[](4);

        ids[0] = 1;
        ids[1] = 2;
        ids[2] = 3;
        ids[3] = 4;

        names[0] = "name";
        names[1] = "age";
        names[2] = "width";
        names[3] = "height";
    }

}
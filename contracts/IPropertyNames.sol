pragma solidity ^0.5.0;

interface IPropertyNames {

    function propertyNames()
        external
        view
        returns(uint256[] memory ids, bytes16[] memory names);
}

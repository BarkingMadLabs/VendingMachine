pragma solidity ^0.5.0;

interface IPropertyNames {

    function propertyNames()
        external
        view
        returns(bytes16[] memory names);
}

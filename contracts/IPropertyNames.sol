pragma solidity ^0.5.0;

interface IPropertyNames {
    function propertyName(uint256 index)
    external
    view
    returns (bytes16 name);
}

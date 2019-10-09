pragma solidity ^0.5.0;

interface IPropertyGenerator {
    function generate(uint256 name)
    external
    returns (uint256 value);
}

pragma solidity ^0.5.0;

interface IPropertyGenerator {
    function generate(address _sender, bytes16 name)
    external
    returns (uint256 value);
}

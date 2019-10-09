pragma solidity ^0.5.0;
import '@openzeppelin/contracts/ownership/Ownable.sol';
import './IPropertyGenerator.sol';

contract PropertyGenerator is IPropertyGenerator, Ownable {

    constructor() public {
    }

    function generate(uint256 name)
        external
        returns (uint256 value) {

        return 1;
    }
}
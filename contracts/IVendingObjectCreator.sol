pragma solidity ^0.5.0;

interface IVendingObjectCreator {

    function mint(address _creator)
        external
        view
        returns(uint256 _tokenId);
}

pragma solidity ^0.5.0;

interface IMetaData {
    function tokenUri(uint256 _tokenId)
        external
        view
        returns(string memory uri);
}
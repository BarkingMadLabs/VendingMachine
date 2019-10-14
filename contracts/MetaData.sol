pragma solidity ^0.5.0;
import "./IMetaData.sol";
import "./helpers/strings.sol";
import '@openzeppelin/contracts/ownership/Ownable.sol';

contract MetaData is IMetaData, Ownable {
    using strings for *;
    string public base;

    constructor(string memory _base)
        public {

        base = _base;
    }

    function tokenUri(uint _tokenId) public view returns (string memory _uri) {
        string memory id = uint2str(_tokenId);
        return base.toSlice().concat(id.toSlice());
    }

    function uint2str(uint i) internal pure returns (string memory) {
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0) {
            uint _uint = 48 + i % 10;
            bstr[k--] = toBytes(_uint)[31];
            i /= 10;
        }
        return string(bstr);
    }

    function toBytes(uint256 x) public pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}
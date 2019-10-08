pragma solidity ^0.5.6;
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./IPropertyNames.sol";
// import "openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol";

contract VendingObject is ERC721Full {

    using SafeMath for uint256;

    uint MAX_PROPERTIES = 16;

    struct Object {
        mapping(uint256 => uint256) properties;
    }

    IPropertyNames public propertyNames;

    mapping(uint256 => Object) internal objects;
    uint256 tokenIdCounter;

    constructor(IPropertyNames _propertyNames) public {
        propertyNames = _propertyNames;
    }

    // TODO need to make this more efficient so that we can just write this number matrix to storage
    function mintObject(address creator, uint256[] memory names, uint256[] memory values)
        public
        returns(uint256 _tokenId) {

        require(creator != address(0x0), 'Invalid creator');
        require(names.length < MAX_PROPERTIES, 'Too many properties');
        require(names.length == values.length, 'Mismatch in names and properties');

        Object memory tmpObj = Object();
        objects[tokenIdCounter.add(1)] = tmpObj;
        Object storage obj = objects[tokenIdCounter];
        for (uint256 i = 0; i < names.length; i++) {
            obj.properties[names[i]] = values[i];
        }

        _mint(creator, tokenIdCounter);

        return tokenIdCounter;
    }

    function property(uint256 _tokenId, uint256 _propertyName)
        public
        view
        returns(uint256 value) {

        require(_exists(_tokenId), 'Invalid token');
        Object storage obj = objects[_tokenId];

        value = obj.properties[_propertyName];
    }

    function properties(uint256 _tokenId, uint256[] memory _propertyNames)
        public
        view
        returns(uint256[] memory) {
        uint256[] memory values = new uint256[](_propertyNames.length);

        require(_exists(_tokenId), 'Invalid token');
        Object storage obj = objects[_tokenId];

        for(uint256 i = 0; i < values.length; i++) {
            values[i] = obj.properties[_propertyNames[i]];
        }

        return values;
    }
}
pragma solidity ^0.5.6;
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./IPropertyNames.sol";
import "./IPropertyGenerator.sol";
import './IVendingObjectCreator.sol';
import "./IMetaData.sol";

// import "openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol";

// Property names are stored on chain as references to the id stored in the object
// as the objects in each machine would be equal in terms of properties

// Property values would also be stored onchain but as ids that are referenced to offchain values

contract VendingObject is ERC721Full, Ownable, IVendingObjectCreator {

    using SafeMath for uint256;

    struct Object {
        mapping(uint256 => uint256) properties;
    }

    IPropertyNames public propertyNames;
    IPropertyGenerator public propertyGenerator;
    IMetaData public metaData;

    mapping(uint256 => Object) internal objects;
    uint256 public tokenIdCounter;

    event test();

    constructor(IMetaData _metaData, IPropertyNames _propertyIds, IPropertyGenerator _propertyGenerator)
        ERC721Full("Vending Object", "VOB")
        public {
        propertyNames = _propertyIds;
        propertyGenerator = _propertyGenerator;
        metaData = _metaData;
    }

    function mint(address _creator)
        public
        returns(uint256 _tokenId) {

        require(_creator != address(0x0), 'Invalid creator');
        (uint256[] memory ids, bytes16[] memory names) = propertyNames.propertyNames();

        Object memory tmpObj = Object();
        tokenIdCounter = tokenIdCounter.add(1);
        objects[tokenIdCounter] = tmpObj;
        Object storage obj = objects[tokenIdCounter];
        for (uint256 i = 0; i < names.length; i++) {
            obj.properties[ids[i]] = propertyGenerator.generate(ids[i]);
        }

        _mint(_creator, tokenIdCounter);

        return tokenIdCounter;
    }

    function tokenURI(uint _tokenId)
        public
        view
        returns (string memory _infoUrl) {
        require(_tokenId > 0, 'Invalid token id');
        return metaData.tokenUri(_tokenId);
    }

    function property(uint256 _tokenId, uint256 _propertyId)
        public
        view
        returns(uint256 value) {

        require(_exists(_tokenId), 'Invalid token');
        Object storage obj = objects[_tokenId];

        value = obj.properties[_propertyId];
    }

    function properties(uint256 _tokenId, uint256[] memory _propertyIds)
        public
        view
        returns(uint256[] memory) {
        uint256[] memory values = new uint256[](_propertyIds.length);

        require(_exists(_tokenId), 'Invalid token');
        Object storage obj = objects[_tokenId];

        for(uint256 i = 0; i < values.length; i++) {
            values[i] = obj.properties[_propertyIds[i]];
        }

        return values;
    }

    function setPropertyGenerator(IPropertyGenerator _propertyGenerator)
        public
        onlyOwner {
        propertyGenerator = _propertyGenerator;
    }

    function setPropertyNames(IPropertyNames _propertyIds)
        public
        onlyOwner {
        propertyNames = _propertyIds;
    }

    function setMetaData(IMetaData _metaData)
        public
        onlyOwner {
        metaData = _metaData;
    }
}
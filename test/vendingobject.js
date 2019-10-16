const VendingObject = artifacts.require("./VendingObject.sol");
const truffleAssert = require('truffle-assertions');

contract("Vending Object", async accounts => {

    let admin, account1; 
    let vendingObjectInstance;
    let tokenId;

    before("should mint a token if admin", async() => {
        [admin, account1] = accounts;

        vendingObjectInstance = await VendingObject.deployed();
        let txObj = await vendingObjectInstance.mint(account1, {from:admin});
        assert.strictEqual(txObj.receipt.logs.length, 1);
        assert.strictEqual(txObj.logs.length, 1);
        const logTransfer = txObj.logs[0];
        
        assert.strictEqual(logTransfer.event, "Transfer");
        assert.strictEqual(logTransfer.args.to, account1);
        tokenId = logTransfer.args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');

        let fn = vendingObjectInstance.mint(account1, {from:account1});
        await truffleAssert.reverts(    fn, 
                                        'WhitelistAdminRole: caller does not have the WhitelistAdmin role');
    });

    it("should have a uri", async () => {
        
        const tokenUri = await vendingObjectInstance.tokenURI(tokenId);
        assert.isString(tokenUri, 'Valid uri for token');
    });
    
    it("should have a property value", async() => {

        const propertyValue = await vendingObjectInstance.property(tokenId, 1);
        assert.isNumber(propertyValue.toNumber(), 'property value are integers');
        assert.strictEqual(propertyValue.toNumber(), 1, 'property value should be 1');
    });

    it("should return properties", async() => {

        let ids = [1,2,3,4];
        const values = await vendingObjectInstance.properties(tokenId, ids);
        assert.strictEqual(values.length, ids.length, 'we should have the same number here');
    });
});
const VendingObject = artifacts.require("./VendingObject.sol");

contract("Vending Object", async accounts => {

    let owner, account1, account2; 
    let vendingObjectInstance;
    let tokenId;

    before("should mint a token", async() => {
        [owner, account1, account2] = accounts;

        vendingObjectInstance = await VendingObject.deployed();
        let txObj = await vendingObjectInstance.mint(account1);
        assert.strictEqual(txObj.receipt.logs.length, 1);
        assert.strictEqual(txObj.logs.length, 1);
        const logTransfer = txObj.logs[0];
        
        assert.strictEqual(logTransfer.event, "Transfer");
        assert.strictEqual(logTransfer.args.to, account1);
        tokenId = logTransfer.args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');
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

        const propertyValue = await vendingObjectInstance.property(tokenId, 1);
        assert.isNumber(propertyValue.toNumber(), 'property value are integers');
        assert.strictEqual(propertyValue.toNumber(), 1, 'property value should be 1');
    });
});
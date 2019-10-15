const VendingMachine = artifacts.require("./VendingMachine.sol");
const VendingObject = artifacts.require("./VendingObject.sol");
const truffleAssert = require('truffle-assertions');
const { toBN, stringToHex, toWei } = web3.utils;

contract("Vending Machine", async accounts => {

    let owner, account1, account2; 
    let vendingMachineInstance;
    let vendingObjectInstance;
    let tokenId;

    before("prepare some things", async function() {
        [owner, account1, account2] = accounts;

        vendingMachineInstance = await VendingMachine.deployed();
        vendingObjectInstance = await VendingObject.deployed();
    });

    it("should mint when sending value", async function() {
        
        let txObj = await vendingMachineInstance.mint({from:account1, value:toWei('0.01', 'ether')});
        assert.strictEqual(txObj.receipt.logs.length, 1);
        assert.strictEqual(txObj.logs.length, 1);
        const logTransfer = txObj.logs[0];
        
        assert.strictEqual(logTransfer.event, "VendingObjectCreated");
        assert.strictEqual(logTransfer.args.to, account1);
        tokenId = logTransfer.args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');
    });
  
    it("should fail when sending 0 value", async function() {
        
        let fn = vendingMachineInstance.mint({from:account1, value:'0'});
        await truffleAssert.reverts(    fn, 
                                        'Send more next time');
    });

    it("should fail when sending 0.001 value", async function() {
        
        let fn = vendingMachineInstance.mint({from:account1, value:toWei('0.001', 'ether')});
        await truffleAssert.reverts(    fn, 
                                        'Send more next time');
    });
});
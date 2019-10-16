const VendingMachine = artifacts.require("./VendingMachine.sol");
const VendingObject = artifacts.require("./VendingObject.sol");
const truffleAssert = require('truffle-assertions');
const { toBN, stringToHex, toWei } = web3.utils;

contract("Vending Machine", async accounts => {

    let admin, account1, account2; 
    let vendingMachineInstance;
    let vendingObjectInstance;
    let tokenId;
    let pricePerVendingObject = toWei('0.001');
    let priceToPay = toWei('0.01');

    beforeEach("prepare some things", async function() {
        [admin, account1, account2] = accounts;

        vendingObjectInstance = await VendingObject.deployed();

        vendingMachineInstance = await VendingMachine.new(  vendingObjectInstance.address, 
                                                            pricePerVendingObject, 
                                                            {from:admin});
        
        vendingObjectInstance.addWhitelistAdmin(vendingMachineInstance.address);
    });

    it("should mint when sending value", async function() {
        
        let txObj = await vendingMachineInstance.mint({from:account1, value:pricePerVendingObject});
        assert.strictEqual(txObj.receipt.logs.length, 1);
        assert.strictEqual(txObj.logs.length, 1);
        const logTransfer = txObj.logs[0];
        
        assert.strictEqual(logTransfer.event, "VendingObjectCreated");
        assert.strictEqual(logTransfer.args.to, account1);
        tokenId = logTransfer.args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');
    });
  
    it("should mint when sending value and allow me to withdraw the change", async function() {
        
        let txObj = await vendingMachineInstance.mint({from:account1, value:priceToPay});
        assert.strictEqual(txObj.receipt.logs.length, 1);
        assert.strictEqual(txObj.logs.length, 1);
        const logTransfer = txObj.logs[0];
        
        assert.strictEqual(logTransfer.event, "VendingObjectCreated");
        assert.strictEqual(logTransfer.args.to, account1);
        tokenId = logTransfer.args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');

        let balanceBN = await vendingMachineInstance.payments(account1);
        let calculatedBalanceBN = toBN(priceToPay).sub(toBN(pricePerVendingObject));
        
        assert.strictEqual(balanceBN.toString(), calculatedBalanceBN.toString(), 'We need to have something left');

        let account1Balance = await web3.eth.getBalance(account1);

        txObj = await vendingMachineInstance.withdrawPayments(account1);
    
        let account1BalanceAfter = await web3.eth.getBalance(account1);
        
        let accountDiff = (toBN(account1BalanceAfter).sub(toBN(account1Balance))).toString();
        
        assert.strictEqual(accountDiff, calculatedBalanceBN.toString());
    });

    it("should fail when sending 0 value", async function() {
        
        let fn = vendingMachineInstance.mint({from:account1, value:'0'});
        await truffleAssert.reverts(    fn, 
                                        'Send more next time');
    });

    it("should fail when sending 0.001 value", async function() {
        
        let fn = vendingMachineInstance.mint({from:account1, value:toWei('0.0009', 'ether')});
        await truffleAssert.reverts(    fn, 
                                        'Send more next time');
    });
});
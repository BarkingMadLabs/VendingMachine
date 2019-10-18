const VendingMachine = artifacts.require("./VendingMachine.sol");
const VendingObject = artifacts.require("./VendingObject.sol");
const truffleAssert = require('truffle-assertions');
const { toBN, stringToHex, toWei } = web3.utils;

contract("Vending Machine", async accounts => {

    let admin, account1, account2; 
    let vendingMachineInstance;
    let vendingObjectInstance;
    let tokenId;
    let pricePerVendingObjectInWei = toWei('0.001');
    let priceToPayInWei = toWei('0.01');
    [admin, account1, account2, shareHolder1, shareHolder2] = accounts;
    let shareHolders = [shareHolder1, shareHolder2];
    let shareHolder1Shares = 50;
    let shareHolder2Shares = 50;
    
    let shareAmounts = [shareHolder1Shares, shareHolder2Shares];

    beforeEach("prepare some things", async function() {
        

        vendingObjectInstance = await VendingObject.deployed();

        vendingMachineInstance = await VendingMachine.new(  shareHolders,
                                                            shareAmounts,
                                                            vendingObjectInstance.address, 
                                                            pricePerVendingObjectInWei, 
                                                            {from:admin});
        
        vendingObjectInstance.addWhitelistAdmin(vendingMachineInstance.address);
    });

    it("should mint when sending value", async function() {
        
        let txObj = await vendingMachineInstance.mint({from:account1, value:pricePerVendingObjectInWei});
        assert.strictEqual(txObj.receipt.logs.length, 1);
        assert.strictEqual(txObj.logs.length, 1);
        const logTransfer = txObj.logs[0];
        
        assert.strictEqual(logTransfer.event, "VendingObjectCreated");
        assert.strictEqual(logTransfer.args.to, account1);
        tokenId = logTransfer.args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');
    });
  
    it("should mint when sending value and allow me to withdraw the change", async function() {
        
        let txObj = await vendingMachineInstance.mint({from:account1, value:priceToPayInWei});
        assert.strictEqual(txObj.receipt.logs.length, 1);
        assert.strictEqual(txObj.logs.length, 1);
        const logTransfer = txObj.logs[0];
        
        assert.strictEqual(logTransfer.event, "VendingObjectCreated");
        assert.strictEqual(logTransfer.args.to, account1);
        tokenId = logTransfer.args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');

        let balanceBN = await vendingMachineInstance.payments(account1);
        let calculatedBalanceBN = toBN(priceToPayInWei).sub(toBN(pricePerVendingObjectInWei));
        
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

    it("should split the contract value", async function() {
        
        let txObj = await vendingMachineInstance.mint({from:account1, value:pricePerVendingObjectInWei});
        tokenId = txObj.logs[0].args.tokenId.toNumber();
        assert.isAbove(tokenId, 0, 'We need a valid token id');

        let balanceOfShareHolder1 = await web3.eth.getBalance(shareHolder1);
        let balanceOfShareHolder2 = await web3.eth.getBalance(shareHolder2);
        
        let txObj1 = await vendingMachineInstance.release(shareHolder1);
        assert.strictEqual(txObj1.logs[0].event, "PaymentReleased");

        let txObj2 = await vendingMachineInstance.release(shareHolder2);
        assert.strictEqual(txObj2.logs[0].event, "PaymentReleased");

        let balanceOfShareHolder1After = await web3.eth.getBalance(shareHolder1);
        let balanceOfShareHolder2After = await web3.eth.getBalance(shareHolder2);
        
        let totalShares = shareHolder1Shares + shareHolder2Shares;
        
        assert.strictEqual( (toBN(balanceOfShareHolder1After).sub(toBN(balanceOfShareHolder1))).toString(),
                            ((toBN(pricePerVendingObjectInWei).mul(toBN(shareHolder1Shares))).div(toBN(totalShares))).toString(), 
                            'Share holder 1 should get their percentage');

        assert.strictEqual( (toBN(balanceOfShareHolder2After).sub(toBN(balanceOfShareHolder2))).toString(),
                            ((toBN(pricePerVendingObjectInWei).mul(toBN(shareHolder1Shares))).div(toBN(totalShares))).toString(), 
                            'Share holder 2 should get their percentage');
    });
});
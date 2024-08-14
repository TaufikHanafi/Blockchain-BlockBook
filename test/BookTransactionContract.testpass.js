const { expect } = require("chai");

describe("BookTransactionContract - Success Tests", function () {
    let bookTransactionContract;
    let deployer, otherAccount;

    beforeEach(async function () {
        [deployer, otherAccount] = await ethers.getSigners();
        const BookTransactionContract = await ethers.getContractFactory("BookTransactionContract");
        bookTransactionContract = await BookTransactionContract.deploy(otherAccount.address, otherAccount.address, otherAccount.address);
        await bookTransactionContract.waitForDeployment();

        // Adding a transaction for testing
        await bookTransactionContract.addTransaction(0, 0, 0, 1, 200);
    });

    it("should add a transaction and retrieve it", async function () {
        const transactionId = 0; // First transaction index
        const transaction = await bookTransactionContract.getTransaction(transactionId);
        expect(transaction.index).to.equal(transactionId);
        expect(transaction.total).to.equal(200);
    });

    it("should successfully set a new total for a transaction", async function () {
        const transactionId = 0;
        const newTotal = 250;
        await bookTransactionContract.setTotal(transactionId, newTotal);
        const updatedTransaction = await bookTransactionContract.getTransaction(transactionId);
        expect(updatedTransaction.total).to.equal(newTotal);
    });
});

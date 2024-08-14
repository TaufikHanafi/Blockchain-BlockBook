const { expect } = require("chai");

describe("BookTransactionContract - Failure Tests", function () {
    let bookTransactionContract;
    let deployer, otherAccount;

    beforeEach(async function () {
        [deployer, otherAccount] = await ethers.getSigners();
        const BookTransactionContract = await ethers.getContractFactory("BookTransactionContract");
        bookTransactionContract = await BookTransactionContract.deploy(otherAccount.address, otherAccount.address, otherAccount.address);
        await bookTransactionContract.waitForDeployment();
    });

    it("should fail to fetch a non-existing transaction", async function () {
        const nonExistingTransactionId = 999;
        await expect(bookTransactionContract.getTransaction(nonExistingTransactionId))
          .to.be.revertedWith("Transaction does not exist.");
    });

    it("should fail to set a total for a non-existing transaction", async function () {
        const nonExistingTransactionId = 999;
        const newTotal = 1000;
        await expect(bookTransactionContract.setTotal(nonExistingTransactionId, newTotal))
          .to.be.revertedWith("Transaction does not exist.");
    });
});

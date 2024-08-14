const { expect } = require("chai");

describe("BookContract - Failure Cases", function () {
    let bookContract;
    let deployer, otherAccount;

    beforeEach(async function () {
        [deployer, otherAccount] = await ethers.getSigners();
        const BookContract = await ethers.getContractFactory("BookContract");
        // Use actual deployed addresses if required or keep using mocks
        bookContract = await BookContract.deploy(otherAccount.address, otherAccount.address, otherAccount.address);
        await bookContract.waitForDeployment();
        // Add a book for the delete test
        await bookContract.addBook("123-4567890123", "Book Title", "Author Name", 0, "checksum123", 100, "cover.jpg", "ebook.pdf", "English", 300);
    });

    it("should fail to get a non-existing book", async function () {
        const nonExistingIndex = 999;
        await expect(bookContract.getBookByIndex(nonExistingIndex)).to.be.revertedWith("Book does not exist");
    });

    it("should fail to delete a book with invalid password", async function () {
        const invalidPassword = "wrongpassword";
        await expect(bookContract.deleteBook(0, invalidPassword)).to.be.reverted;
    });
    
});

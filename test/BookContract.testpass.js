const { expect } = require("chai");

describe("BookContract - Success Cases", function () {
    let bookContract;
    let deployer, otherAccount;

    beforeEach(async function () {
        [deployer, otherAccount] = await ethers.getSigners();
        const BookContract = await ethers.getContractFactory("BookContract");
        bookContract = await BookContract.deploy(otherAccount.address, otherAccount.address, otherAccount.address);
        await bookContract.waitForDeployment();

        // Initial setup: adding a book
        await bookContract.addBook("123-4567890123", "Book Title", "Author Name", 0, "checksum123", 100, "cover.jpg", "ebook.pdf", "English", 300);
    });

    it("should add a book and retrieve it", async function () {
        const newBookIndex = 1;
        await bookContract.addBook("987-6543210987", "New Book", "New Author", 0, "checksum987", 150, "newcover.jpg", "newebook.pdf", "Spanish", 250);

        const book = await bookContract.getBookByIndex(newBookIndex);
        expect(book.isbn).to.equal("987-6543210987");
        expect(book.title).to.equal("New Book");
    });

    it("should set a book visible and check visibility", async function () {
        const adminPassword = "adminpass"; // Assume this is a valid password setup in the AdminContract mock
        await bookContract.setVisible(0, true, adminPassword);

        const book = await bookContract.getBookByIndex(0);
        expect(book.visible).to.be.true;
    });

    it("should delete a book and check deletion status", async function () {
        const adminPassword = "adminpass"; // This should be a valid password
        await bookContract.deleteBook(0, adminPassword);

        const book = await bookContract.getBookByIndex(0);
        expect(book.deleted).to.be.true;
    });
});

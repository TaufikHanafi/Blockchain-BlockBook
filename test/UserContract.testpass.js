const { expect } = require("chai");

describe("UserContract - Pass Tests", function () {
    let userContract;
    let deployer;

    beforeEach(async function () {
        [deployer] = await ethers.getSigners();
        const UserContract = await ethers.getContractFactory("UserContract");
        userContract = await UserContract.deploy();
        await userContract.waitForDeployment();
    });

    it("should add a user and retrieve it", async function () {
        const name = "John Doe";
        const email = "john.doe@example.com";
        const accessKey = "secureKey123";
        await userContract.addUser(name, email, accessKey);

        const addedUser = await userContract.getUser(0);
        expect(addedUser.name).to.equal(name);
        expect(addedUser.email).to.equal(email);
        expect(addedUser.index).to.equal(0);
    });

    it("should edit a user and verify changes", async function () {
        const name = "Jane Doe";
        const email = "jane.doe@example.com";
        const accessKey = "secureKey123";
        await userContract.addUser(name, email, accessKey);

        const newName = "Jane Smith";
        const newEmail = "jane.smith@example.com";
        const newAccessKey = "newSecureKey456";
        await userContract.editUser(0, newName, newEmail, newAccessKey);

        const editedUser = await userContract.getUser(0);
        expect(editedUser.name).to.equal(newName);
        expect(editedUser.email).to.equal(newEmail);
    });
});

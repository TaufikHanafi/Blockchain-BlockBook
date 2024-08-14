const { expect } = require("chai");

describe("UserContract - Fail Tests", function () {
    let userContract;
    let deployer;

    beforeEach(async function () {
        [deployer] = await ethers.getSigners();
        const UserContract = await ethers.getContractFactory("UserContract");
        userContract = await UserContract.deploy();
        await userContract.waitForDeployment();
    });

    it("should fail to find a non-existing user", async function () {
        const nonExistingIndex = 999; // Assumed to be a non-existing index
        await expect(userContract.getUser(nonExistingIndex))
          .to.be.revertedWith("User not found");
    });

    it("should fail to edit a non-existing user", async function () {
        const nonExistingIndex = 999;
        const newName = "New Name";
        const newEmail = "newemail@example.com";
        const newAccessKey = "newAccess123";
        await expect(userContract.editUser(nonExistingIndex, newName, newEmail, newAccessKey))
          .to.be.revertedWith("User not found");
    });
});

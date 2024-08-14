const { expect } = require("chai");

describe("PubliserContract - Fail Tests", function () {
    let publiserContract;
    let deployer;

    beforeEach(async function () {
        const [owner] = await ethers.getSigners();
        deployer = owner;
        const PubliserContract = await ethers.getContractFactory("PubliserContract");
        publiserContract = await PubliserContract.deploy();
        await publiserContract.waitForDeployment();
    });

    it("should fail to find a non-existing publiser", async function () {
        const nonExistingIndex = 999; 
        await expect(publiserContract.getPubliser(nonExistingIndex)).to.be.revertedWith("Publiser not found");
    });
});

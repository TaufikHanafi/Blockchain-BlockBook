const { expect } = require("chai");

describe("PubliserContract - Pass Tests", function () {
    let publiserContract;
    let deployer;

    beforeEach(async function () {
        const [owner] = await ethers.getSigners();
        deployer = owner;
        const PubliserContract = await ethers.getContractFactory("PubliserContract");
        publiserContract = await PubliserContract.deploy();
        await publiserContract.waitForDeployment();
    });

    it("should add a publiser and retrieve it", async function () {
        const name = "John Doe";
        const email = "john.doe@example.com";
        const identitas = "ID123456";
        const bankId = 1;
        const accessKey = "secureAccessKey";

        await publiserContract.addPubliser(name, email, identitas, bankId, accessKey);
        const retrievedPubliser = await publiserContract.getPubliser(0);

        expect(retrievedPubliser.name).to.equal(name);
        expect(retrievedPubliser.email).to.equal(email);
        expect(retrievedPubliser.Identitas).to.equal(identitas);
        expect(retrievedPubliser.bankId).to.equal(bankId);
    });

    it("should correctly handle publiser count", async function () {
        const initialCount = await publiserContract.getAllPublisers();
        expect(initialCount.length).to.equal(0);

        await publiserContract.addPubliser("Jane Doe", "jane.doe@example.com", "ID654321", 2, "secureKey123");
        const newCount = await publiserContract.getAllPublisers();
        expect(newCount.length).to.equal(1);
    });
});

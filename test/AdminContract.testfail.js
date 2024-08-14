const { expect } = require("chai");

describe("AdminContract - Fail Test", function () {
  let adminContract;
  let deployer;

  beforeEach(async function () {
    const [owner] = await ethers.getSigners();
    deployer = owner;
    const AdminContract = await ethers.getContractFactory("AdminContract");
    adminContract = await AdminContract.deploy();
    await adminContract.waitForDeployment();
  });

  it("should fail to verify an admin that does not exist", async function () {
    // Menambahkan admin
    await adminContract.addAdmin("testpassword123");
    // Mengecek admin dengan password yang salah seharusnya mengembalikan false
    expect(await adminContract.checkAdmin("wrongpassword")).to.be.false;
  });
});

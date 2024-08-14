const { expect } = require("chai");

describe("AdminContract - Pass Test", function () {
  let adminContract;
  let deployer;

  beforeEach(async function () {
    const [owner] = await ethers.getSigners();
    deployer = owner;
    const AdminContract = await ethers.getContractFactory("AdminContract");
    adminContract = await AdminContract.deploy();
    await adminContract.waitForDeployment();
  });

  it("should correctly add and verify an admin", async function () {
    // Menambahkan admin dengan password tertentu
    const password = "testpassword123";
    await adminContract.addAdmin(password);
    // Mengecek apakah admin dengan password yang benar dapat diverifikasi
    expect(await adminContract.checkAdmin(password)).to.be.true;
  });
});

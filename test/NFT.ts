import { ethers } from "hardhat";
import { Signer } from "ethers";
import { expect } from "chai";
import { Contract } from "ethers";

describe("NFT Contract", function () {
  let nft: Contract;
  let owner: Signer;
  let addr1: Signer;
  let addr2: Signer;

  beforeEach(async () => {
    const NFT = await ethers.getContractFactory("NFT");
    [owner, addr1, addr2] = await ethers.getSigners();

    nft = await NFT.deploy();
  });

  it("should mint a new NFT", async function () {
    const initialSupply = await nft.totalSupply();
    expect(initialSupply.toString()).to.equal("0");

    await nft.connect(addr1).mint({ value: ethers.utils.parseEther("0.0005") });

    const newSupply = await nft.totalSupply();
    expect(newSupply.toString()).to.equal("1");

    const ownerOfNFT = await nft.ownerOf(1);
    expect(ownerOfNFT).to.equal(await addr1.getAddress());
  });

  it("should pause and unpause the contract", async function () {
    expect(await nft.paused()).to.equal(false);

    await nft.pause(true);
    expect(await nft.paused()).to.equal(true);

    await nft.pause(false);
    expect(await nft.paused()).to.equal(false);
  });

  it("should withdraw contract balance", async function () {
    await nft.connect(addr2).mint({ value: ethers.utils.parseEther("0.0005") });

    const contractBalanceBefore = await ethers.provider.getBalance(nft.address);
    expect(contractBalanceBefore.toString()).to.equal("500000000000000");

    const ownerBalanceBefore = await ethers.provider.getBalance(
      await owner.getAddress()
    );

    await nft.withdraw();

    const contractBalanceAfter = await ethers.provider.getBalance(nft.address);
    expect(contractBalanceAfter.toString()).to.equal("0");

    const ownerBalanceAfter = await ethers.provider.getBalance(
      await owner.getAddress()
    );

    expect(ownerBalanceAfter.gt(ownerBalanceBefore)).to.equal(true);
  });
});

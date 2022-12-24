import { ethers } from 'hardhat';

async function main() {
	const POC = await ethers.getContractFactory('POC');
	const poc = await POC.deploy('0x688160C614c63e49C4cd59246e546b3bE03C43fd');
	await poc.deployed();
	console.log('POCToken deployed to : ', poc.address);

	const EnglishAuction = await ethers.getContractFactory('EnglishAuction');
	const englishAuction = await EnglishAuction.deploy(poc.address);
	await englishAuction.deployed();
	console.log('EnglishAuction deployed to : ', englishAuction.address);
}
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});

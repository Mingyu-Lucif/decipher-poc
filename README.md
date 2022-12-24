# decipher-poc
[Decipher](https://decipher.ac/) PoC(Proof of Contribution)

## Minor Changes
* AccessControl Integrated with, AdminRole, OperatorRole
* Token Naming with string(abi.encodePacked(name(), epoch())
* Token Symbol with string(abi.encodePacked(symbol(), epoch())
* Implemented BidAuction for English Auction

## TODO
* Role Fixes
* Auction Details
* Minor View functions for F/E

* Role
```shell
$ npx hardhat compile
$ npx hardhat deploy
$ npx hardhat node
$ npx hardhat run scripts/create_poc_holders.js --network localhost
```

// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;


import "./extensions/ERC20Epochs.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract POC is ERC20Epochs, AccessControl {

	bytes32 public constant ADMIN_ROLE = keccak256('ADMIN_ROLE');
	bytes32 public constant OPERATOR_ROLE = keccak256('OPERATOR_ROLE');

    constructor(address adminAddress) ERC20Epochs("POC", "POC") {
        _grantRole(ADMIN_ROLE, adminAddress);
        _setRoleAdmin(OPERATOR_ROLE, ADMIN_ROLE);
    }

    // Examples for POC(Proof of Contribution) specific logics. Constant
    function name() public view override returns (string memory) {
        return string(abi.encodePacked(super.name(), epoch()));
    }

    function symbol() public view override returns (string memory) {
        return string(abi.encodePacked(super.symbol(), epoch()));
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function createEpoch() public onlyRole(OPERATOR_ROLE){
        _createEpoch();
    }

    // Roles Admin, Operator
    function changeAdminRole(address adminAddress) public {
        require(hasRole(ADMIN_ROLE, msg.sender));
        _grantRole(ADMIN_ROLE, adminAddress);
        _revokeRole(ADMIN_ROLE, msg.sender);
    }

    function setOperatorRole(address operatorAddress) public {
        require(hasRole(ADMIN_ROLE, msg.sender));
        _grantRole(OPERATOR_ROLE, operatorAddress);
    }

    function revokeOperatorRole(address operatorAddress) public {
        require(hasRole(ADMIN_ROLE, msg.sender));
        _revokeRole(OPERATOR_ROLE, operatorAddress);
    }
}
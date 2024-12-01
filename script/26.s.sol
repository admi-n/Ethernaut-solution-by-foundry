// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/26-DoubleEntryPoint.sol"; 


contract DetectionBot is IDetectionBot {
    address private monitoredSource;
    bytes private monitoredSig;

    constructor(address _monitoredSource, bytes memory _monitoredSig) {
        monitoredSource = _monitoredSource;
        monitoredSig = _monitoredSig;
    }

    function handleTransaction(address user, bytes calldata msgData) external override {
        (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address, uint256, address));

        bytes memory callSig = abi.encodePacked(msgData[0], msgData[1], msgData[2], msgData[3]);

        // 如果原始发送者是 CryptoVault 地址 并且签名匹配 delegateTransfer 的签名
        if (origSender == monitoredSource && keccak256(callSig) == keccak256(monitoredSig)) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}

contract Exp is Script {
    DoubleEntryPoint public DoubleEntryPointInstance = DoubleEntryPoint(payable(/*获取的实例地址*/));
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    address owner = vm.envAddress("MY_ADDRESS");

    function attack() public {
        address cryptoVault = DoubleEntryPointInstance.cryptoVault();

        DetectionBot bot = new DetectionBot(cryptoVault,abi.encodeWithSignature("delegateTransfer(address,uint256,address)"));
        DoubleEntryPointInstance.forta().setDetectionBot(address(bot));
    }

    function run() external {
        vm.startBroadcast(hacker);

        attack();

        vm.stopBroadcast();
    }
}

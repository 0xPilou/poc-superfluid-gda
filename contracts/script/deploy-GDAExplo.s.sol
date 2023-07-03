// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "src/GDAExplo.sol";

contract DeployGDAExplo is Script {
    function run() external {
        address mockSuperToken = 0x7CC7c6a3A382F5E2F4e8298F664aAD3e87751a0e;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new GDAExplo(mockSuperToken);

        vm.stopBroadcast();
    }
}

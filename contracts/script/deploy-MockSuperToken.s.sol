// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "src/MockSuperToken.sol";

contract DeployMockSuperToken is Script {
    address public constant SF_HOST = 0xE40983C2476032A0915600b9472B3141aA5B5Ba9;
    address public constant SF_CONSTANT_OUTFLOW_NFT = 0xDF874BA132D8C68FEb5De513790f7612Fe20dDbd;
    address public constant SF_CONSTANT_INFLOW_NFT = 0xf88dd7208438Fdc5Ad05857eA701b7b51cdae0a9;
    address public constant SF_POOL_ADMIN_NFT = 0xf4a0ce50ab43Cd3d297607Eb6599750864AA3ED2;
    address public constant SF_POOL_MEMBER_NFT = 0x862F59081FC7907F940bE4227b9f485d700E6cdD;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        new MockSuperToken(
            SF_HOST,
            SF_CONSTANT_OUTFLOW_NFT,
            SF_CONSTANT_INFLOW_NFT,
            SF_POOL_ADMIN_NFT,
            SF_POOL_MEMBER_NFT
        );

        vm.stopBroadcast();
    }
}

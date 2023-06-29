// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {MockSuperToken} from "src/MockSuperToken.sol";
import {GDAExplo} from "src/GDAExplo.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {ISuperfluidPool} from
    "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluidPool.sol";

contract GDAExploTest is Test {
    using SuperTokenV1Library for MockSuperToken;

    address public constant SF_HOST = 0xE40983C2476032A0915600b9472B3141aA5B5Ba9;
    address public constant SF_CONSTANT_OUTFLOW_NFT = 0xDF874BA132D8C68FEb5De513790f7612Fe20dDbd;
    address public constant SF_CONSTANT_INFLOW_NFT = 0xf88dd7208438Fdc5Ad05857eA701b7b51cdae0a9;
    address public constant SF_POOL_ADMIN_NFT = 0xf4a0ce50ab43Cd3d297607Eb6599750864AA3ED2;
    address public constant SF_POOL_MEMBER_NFT = 0x862F59081FC7907F940bE4227b9f485d700E6cdD;
    address public constant SF_GDA = 0xe87F46A15C410F151309Bf7516e130087Fc6a5E5;

    address payable public alice;

    GDAExplo public gdaExplo;
    MockSuperToken public mockToken;

    function setUp() public {
        vm.selectFork(vm.createFork(vm.envString("OPTIMISM_GOERLI_RPC")));

        alice = payable(vm.addr(1));
        vm.deal(alice, 100 ether);

        mockToken =
        new MockSuperToken(SF_HOST, SF_CONSTANT_OUTFLOW_NFT, SF_CONSTANT_INFLOW_NFT, SF_POOL_ADMIN_NFT, SF_POOL_MEMBER_NFT);

        gdaExplo = new GDAExplo(address(mockToken));

        vm.label(alice, "alice");
        vm.label(address(mockToken), "mockToken");
        vm.label(address(gdaExplo), "gdaExplo");
    }

    function test_addUnit() public {
        // gdaExplo.createPool();

        address pool = address(mockToken.createPool(address(gdaExplo)));
        gdaExplo.setPool(pool);

        vm.prank(alice);

        gdaExplo.addUnit();
    }

    // function test_createPool() public {
    //     gdaExplo.createPool();

    //     console.logAddress(address(gdaExplo.pool()));

    //     console.logUint(gdaExplo.pool().getTotalUnits());
    // }
}

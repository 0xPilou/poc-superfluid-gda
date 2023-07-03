// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title GDAExplo
 * @author 0xPilou
 * @notice Exploration around Superfluid General Distribution Agreement
 *
 */

/* Superfluid Contracts */
import {
    ISuperToken,
    ISuperfluidToken
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";
import {ISuperfluidPool} from
    "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluidPool.sol";
import {IGeneralDistributionAgreementV1} from
    "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IGeneralDistributionAgreementV1.sol";

import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

/// @dev errors thrown when attempting to perform forbidden operation
error FORBIDDEN();

contract GDAExplo {
    using SuperTokenV1Library for ISuperToken;

    // //     _____ __        __
    // //    / ___// /_____ _/ /____  _____
    // //    \__ \/ __/ __ `/ __/ _ \/ ___/
    // //   ___/ / /_/ /_/ / /_/  __(__  )
    // //  /____/\__/\__,_/\__/\___/____/

    /// @dev owner of this contract
    address admin;

    /// @dev currency paid to subscribers by this contract
    ISuperToken public currency;

    /// @dev Superfluid pool holding the tokens paid to subscribers
    mapping(uint256 _poolId => ISuperfluidPool pool) public pools;

    /// @dev Superfluid General Distribution Agreement interface
    IGeneralDistributionAgreementV1 public gda =
        IGeneralDistributionAgreementV1(0xe87F46A15C410F151309Bf7516e130087Fc6a5E5);

    //     ______                 __                  __
    //    / ____/___  ____  _____/ /________  _______/ /_____  _____
    //   / /   / __ \/ __ \/ ___/ __/ ___/ / / / ___/ __/ __ \/ ___/
    //  / /___/ /_/ / / / (__  ) /_/ /  / /_/ / /__/ /_/ /_/ / /
    //  \____/\____/_/ /_/____/\__/_/   \__,_/\___/\__/\____/_/

    /**
     * @notice
     *  Contract Constructor
     */
    constructor(address _currency) {
        admin = msg.sender;
        currency = ISuperToken(_currency);
    }

    //     ______     __                        __   ______                 __  _
    //    / ____/  __/ /____  _________  ____ _/ /  / ____/_  ______  _____/ /_(_)___  ____  _____
    //   / __/ | |/_/ __/ _ \/ ___/ __ \/ __ `/ /  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
    //  / /____>  </ /_/  __/ /  / / / / /_/ / /  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  )
    // /_____/_/|_|\__/\___/_/  /_/ /_/\__,_/_/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/

    function addUnit(uint256 _poolId, uint256 _amount) external {
        // Get the pool corresponding to _poolId
        ISuperfluidPool pool = pools[_poolId];

        // Get the subscriber's current units
        uint128 callerUnits = pool.getUnits(msg.sender);

        // Add 1 unit to the caller's current units amount
        pool.updateMember(msg.sender, callerUnits + _amount);
    }

    function removeUnit(uint256 _poolId, uint128 _amount) external {
        // Get the pool corresponding to _poolId
        ISuperfluidPool pool = pools[_poolId];

        // Get the subscriber's current units
        uint128 callerUnits = pool.getUnits(msg.sender);

        if (callerUnits > _amount) {
            // Remove 1 unit from the caller's current units amount
            pool.updateMember(msg.sender, callerUnits - _amount);
        } else {
            // Delete the caller's subscription
            pool.updateMember(msg.sender, 0);
        }
    }

    //    ____        __         ___       __          _
    //   / __ \____  / /_  __   /   | ____/ /___ ___  (_)___
    //  / / / / __ \/ / / / /  / /| |/ __  / __ `__ \/ / __ \
    // / /_/ / / / / / /_/ /  / ___ / /_/ / / / / / / / / / /
    // \____/_/ /_/_/\__, /  /_/  |_\__,_/_/ /_/ /_/_/_/ /_/
    //              /____/

    function createPool(uint256 _poolId) external {
        if (msg.sender != admin) revert FORBIDDEN();
        pools[_poolId] = gda.createPool(address(this), currency);
    }

    function startStream(uint256 _poolId, int96 _flowRate) external {
        if (msg.sender != admin) revert FORBIDDEN();
        currency.distributeFlow(address(this), pools[_poolId], _flowRate, new bytes(0));
    }
}

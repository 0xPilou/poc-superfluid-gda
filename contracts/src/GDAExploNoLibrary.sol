// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title GDAExploNoLibrary
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

/// @dev errors thrown when attempting to perform forbidden operation

error FORBIDDEN();

contract GDAExploNoLibrary {
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
    ISuperfluidPool public pool;

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

    function addUnit() external {
        // Get the subscriber's current units
        uint128 callerUnits = pool.getUnits(msg.sender);

        // Add 1 unit to the caller's current units amount
        pool.updateMember(msg.sender, callerUnits + 1);
    }

    function removeUnit() external {
        // Get the subscriber's current units
        uint128 callerUnits = pool.getUnits(msg.sender);

        if (callerUnits > 1) {
            // Remove 1 unit from the caller's current units amount
            pool.updateMember(msg.sender, callerUnits - 1);
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

    function createPool() external {
        if (msg.sender != admin) revert FORBIDDEN();
        pool = gda.createPool(ISuperfluidToken(address(currency)), address(this));
    }

    function startStream(int96 _flowRate) external {
        if (msg.sender != admin) revert FORBIDDEN();
        gda.distributeFlow(ISuperfluidToken(address(currency)), address(this), pool, _flowRate, "");
    }
}

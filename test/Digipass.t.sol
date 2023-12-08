// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Digipass} from "../src/Digipass.sol";

contract DigipassTest is Test {
    Digipass public digipass;

    function setUp() public {
        digipass = new Digipass();
       
    }


}

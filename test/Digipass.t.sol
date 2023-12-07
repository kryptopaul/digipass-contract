// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Digipass} from "../src/Digipass.sol";

contract DigipassTest is Test {
    Digipass public digipass;

    function setUp() public {
        digipass = new Digipass();
       
    }
    function test_assignTravel() public {
         digipass.assignTravel(1,2,"Waterloo", "https://oaidalleapiprodscus.blob.core.windows.net/private/org-55yTuhzoSimH60B85vEr7HlA/user-g3GFdTthyDz77tUBH2n6lmnS/img-rPH4BrOzvtT81vprZkLiUD9F.png?st=2023-12-07T18%3A17%3A31Z&se=2023-12-07T20%3A17%3A31Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-12-07T16%3A43%3A15Z&ske=2023-12-08T16%3A43%3A15Z&sks=b&skv=2021-08-06&sig=dFxCoMczOJH/W2Zc8qwYqJbCrfNKGXZoWsxefMqPIpA%3D");
    }

}

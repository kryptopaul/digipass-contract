// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "ERC721A/extensions/ERC721AQueryable.sol";
import {FunctionsClient} from "chainlink/src/v0.8/functions/dev/v1_X/FunctionsClient.sol";
import {ConfirmedOwner} from "chainlink/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsRequest} from "chainlink/src/v0.8/functions/dev/v1_X/libraries/FunctionsRequest.sol";

contract Digipass is ERC721AQueryable, FunctionsClient, ConfirmedOwner {
    using FunctionsRequest for FunctionsRequest.Request;
    // State variables to store the last request ID, response, and error
    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;

    // Custom error type
    error UnexpectedRequestID(bytes32 requestId);

    // Event to log responses
    event Response(
        bytes32 indexed requestId,
        string price,
        bytes response,
        bytes err
    );

    // Router address - Hardcoded for Mumbai
    // Check to get the router address for your supported network https://docs.chain.link/chainlink-functions/supported-networks
    address router = 0xA9d587a00A31A52Ed70D6026794a8FC5E2F5dCb0;
    // JavaScript source code
    // Fetch character name from the Star Wars API.
    // Documentation: https://swapi.dev/documentation#people
    string source =
        "const price = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://digipass-ui.vercel.app/api/price?destination=${price}`"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data.price);";

    //Callback gas limit
    uint32 gasLimit = 300000;

    // donID - Hardcoded for Mumbai
    // Check to get the donID for your supported network https://docs.chain.link/chainlink-functions/supported-networks
    bytes32 donID =
        0x66756e2d6176616c616e6368652d66756a692d31000000000000000000000000;

    // State variable to store the returned character information
    string public price;

    constructor()
        ERC721A("Digipass", "DGP")
        FunctionsClient(router)
        ConfirmedOwner(msg.sender)
    {}

    /**
     * @notice Sends an HTTP request for character information
     * @param subscriptionId The ID for the Chainlink subscription
     * @param args The arguments to pass to the HTTP request
     * @return requestId The ID of the request
     */
    function sendRequest(
        uint64 subscriptionId,
        string[] calldata args,
        string calldata imageUri
    ) external returns (bytes32 requestId) {
        if (balanceOf(msg.sender) == 0) revert();
        FunctionsRequest.Request memory req;
        req._initializeRequestForInlineJavaScript(source); // Initialize the request with JS code
        if (args.length > 0) req._setArgs(args); // Set the arguments for the request

        // Send the request and store the request ID
        s_lastRequestId = _sendRequest(
            req._encodeCBOR(),
            subscriptionId,
            gasLimit,
            donID
        );

        uint256 targetToken = this.tokensOfOwner(msg.sender)[0];
        travels.push(
            Travel({
                chainlinkId: s_lastRequestId,
                tokenId: targetToken,
                timestamp: block.timestamp,
                price: "",
                destination: args[0],
                uri: imageUri
            })
        );

        return s_lastRequestId;
    }

    /**
     * @notice Callback function for fulfilling a request
     * @param requestId The ID of the request to fulfill
     * @param response The HTTP response data
     * @param err Any errors from the Functions request
     */
    function _fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }
        // Update the contract's state variables with the response and any errors
        s_lastResponse = response;
        price = string(response);
        s_lastError = err;
        // Find travel with a given id and update price param to string(response)
        for (uint256 i = 0; i < travels.length; i++) {
            if (travels[i].chainlinkId == requestId) {
                travels[i].price = price;
            }
        }

        // Emit an event to log the response
        emit Response(requestId, price, s_lastResponse, s_lastError);
    }

    struct Travel {
        bytes32 chainlinkId;
        uint256 tokenId;
        uint256 timestamp;
        string price;
        string destination;
        string uri;
    }

    Travel[] public travels;

    function tokenURI(
        uint256 tokenId
    ) public view virtual override(ERC721A, IERC721A) returns (string memory) {
        return "https://digipass-ui.vercel.app/api/metadata";
    }

    function mint() external payable {
        if (_numberMinted(msg.sender) > 0) revert();
        _mint(msg.sender, 1);
    }

    function getTravels() external view returns (Travel[] memory) {
        return travels;
    }
}

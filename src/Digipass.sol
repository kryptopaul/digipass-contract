pragma solidity 0.8.21;

import "ERC721A/ERC721A.sol";

contract Digipass is ERC721A {
    struct Travel {
        uint256 timestamp;
        uint256 price;
        string destination;
        string uri;
    }
    string url = "https://oaidalleapiprodscus.blob.core.windows.net/private/org-55yTuhzoSimH60B85vEr7HlA/user-g3GFdTthyDz77tUBH2n6lmnS/img-rPH4BrOzvtT81vprZkLiUD9F.png?st=2023-12-07T18%3A17%3A31Z&se=2023-12-07T20%3A17%3A31Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-12-07T16%3A43%3A15Z&ske=2023-12-08T16%3A43%3A15Z&sks=b&skv=2021-08-06&sig=dFxCoMczOJH/W2Zc8qwYqJbCrfNKGXZoWsxefMqPIpA%3D";

    mapping(uint256 => Travel[]) travels;

    constructor() ERC721A("Digipass", "DP") {}

    function mint() external payable {
        if (_numberMinted(msg.sender) > 0) revert();
        _mint(msg.sender, 1);
    }

    function assignTravel(uint256 tokenId, uint256 price, string memory destination, string memory uri) external {
        travels[tokenId].push(Travel(block.timestamp, price, destination, uri));
    }


}


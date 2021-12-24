// SPDX-License-Identifier: MIT
// We will be using Solidity version 0.5.3
pragma solidity 0.8.0;
// Importing OpenZeppelin's ERC-721 Implementation
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
// Importing OpenZeppelin's SafeMath Implementation
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract NftToken is ERC721 {
    using SafeMath for uint256;
    // This struct will be used to represent one viper

    // List of existing vipers
    // Viper[] public vipers;

    struct Nft {
        uint8 genes;
        uint256 matronId;
        uint256 sireId;
    }

    uint256[] public nextNft;

    // Initializing an ERC-721 Token named 'Vipers' with a symbol 'VPR'
    constructor() ERC721("MyNFT", "MNFT") {}

    /** @dev Function to create a new viper
     * @param matron ID of new viper's matron (one parent)
     * @param sire ID of new viper's sire (other parent)
     * @param viperOwner Address of new viper's owner
     * @return The new viper's ID
     */
    function addNFT(uint256 nftId, address nftOwner)
        internal
        returns (uint256)
    {
        require(nftOwner != address(0));

        MyNft.push(nftId);
        uint256 newNftId = MyNft.length - 1;
        super._mint(nftOwner, newNftId);

        return newNftId;
    }

    /** @dev Function to allow user to buy a new viper (calls createViper())
     * @return The new viper's ID
     */
    function buyNFT(uint256 nftId) external payable returns (uint256) {
        require(msg.value == 0.003 ether);
        return addNFT(nftId, msg.sender);
    }

    /** @dev Function to get a list of owned vipers' IDs
     * @return A uint array which contains IDs of all owned vipers
     */
    function ownedNft() external view returns (uint256[] memory) {
        uint256 nftCount = balanceOf(msg.sender);
        if (nftCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](viperCount);
            uint256 totalNft = MyNft.length;
            uint256 resultIndex = 0;
            uint256 nftId = 0;
            while (nftId < totalNft) {
                if (ownerOf(nftId) == msg.sender) {
                    result[resultIndex] = nftId;
                    resultIndex = resultIndex.add(1);
                }
                nftId = nftId.add(1);
            }
            return result;
        }
    }

    function getNftDetails(uint256 nftId) external view returns (string) {
        return
            string(
                abi.encodePacked(
                    "http://localhost:8080/api/nftmeta/",
                    MyNft[nftId]
                )
            );
    }

    function _baseURI() internal view override returns (string memory) {
        return "http://localhost:8080/api/nftmeta/";
    }
}

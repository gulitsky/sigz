// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

error SigzInvalidSignature(address signer, string message, bytes signature);
error SigzTokenAlreadyMinted(uint256 tokenId, address signer, string message, bytes signature);

contract Sigz is Context, ERC721("Sigz", "SIGZ"), ERC721Enumerable {
    struct SignedMessage {
        string message;
        bytes signature;
    }

    mapping(uint256 => SignedMessage) public signedMessages;
    mapping(bytes => uint256) public signatures;

    function mint(address signer, string calldata message, bytes calldata signature) external {
        if (!SignatureChecker.isValidSignatureNow(signer, keccak256(bytes(message)), signature)) {
            revert SigzInvalidSignature(signer, message, signature);
        }

        if (signatures[signature] > 0) {
            revert SigzTokenAlreadyMinted(signatures[signature], signer, message, signature);
        }

        uint256 tokenId = totalSupply() + 1;
        signedMessages[tokenId] = SignedMessage(message, signature);
        _safeMint(_msgSender(), tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        string memory json = ;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}

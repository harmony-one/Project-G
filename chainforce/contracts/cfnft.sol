// SPDX-License-Identifier: MIT
// Chain Force ERC721 Contract
// Adam Androulidakis March 2024

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CFNFT is ERC721, Pausable, AccessControl {
    uint256 private _tokenIdCounter;

    bytes32 public constant CUSTODIAN_ROLE = keccak256("CUSTODIAN_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    string _baseURIextended;

    mapping ( uint256 => string ) attribute;
    mapping (uint256 => address) private _owners;

    constructor( address _newcustodian) ERC721("Chain Force", "CFNFT") {
      _grantRole(OWNER_ROLE, msg.sender);
      _grantRole(CUSTODIAN_ROLE, _newcustodian);
      _baseURIextended = "https://???/nftmeta/";
    }

    function pause() external onlyRole(CUSTODIAN_ROLE) whenNotPaused{
        _pause();
    }

    function unpause() external onlyRole(CUSTODIAN_ROLE) whenPaused{
        _unpause();
    }

    function setBaseURI(string memory baseURI_) external onlyRole(OWNER_ROLE)  {
        _baseURIextended = baseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory){
      require(_ownerOf(_tokenId) != address(0));
      return string(abi.encodePacked(_baseURI(), attribute[_tokenId], ".json"));
    }

    function safeMint(address receiver) public onlyRole(CUSTODIAN_ROLE) {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(receiver, tokenId);
        _tokenIdCounter += 1;
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    receive () external payable {
      revert();
    }

}
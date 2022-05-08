// SPDx-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Base64} from "./util/Base64.sol";
import {StringUtils} from "./util/StringUtils.sol";

contract DomainNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string public topDomainName;

    // Mapping domain to owner address
    mapping(string => address) public domains;

    // Domain URI
    mapping(string => string) public records;

    // List of domain names
    mapping(uint256 => string) public names;

    string svgPartOne =
        '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#10Af0e"/><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"/></linearGradient></defs><path d="M60.000002,123.665974c0,0,0,0,58.288492-38.856776c58.274689,38.856776,58.274689,38.856776,58.274689,38.856776s0,67.999359,0,67.999359-42.740363,0-42.740363,0s0-25.356777,0-38.856776c-12,0-19.068652,0-31.068652,0c0,13.499999,0,38.856776,0,38.856776q-42.754166,0-42.754166,0c0,0,0-67.999359,0-67.999359Z" transform="matrix(1.029977 0 0 1.029421 28.165572 2.695657)" fill="#fff" stroke-width="0"/><text x="62.5" y="60" font-size="27" fill="#fff" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = "</text></svg>";

    constructor(string memory tld) payable ERC721("DomainNFT", "DNFT") {
        topDomainName = tld;
    }

    function safeMint(string calldata name, string memory description)
        public
        payable
    {
        require(domains[name] == address(0), "Domain name is taken");
        require(valid(name), "Name is not valid");

        uint256 _price = price();
        require(msg.value >= _price, "Not enough tokens paid");

        // Combine the name passed into the function  with the TLD
        string memory _name = string(
            abi.encodePacked(name, ".", topDomainName)
        );
        // Create the SVG (image) for the NFT with the name
        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, _name, svgPartTwo)
        );

        uint256 newRecordId = _tokenIdCounter.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the Ninja name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[_name] = msg.sender;
        names[newRecordId] = _name;
        setRecord(_name, description);

        _tokenIdCounter.increment();
    }

    //    admin function to withdraw all funds
    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw tokens");
    }

    //    admin function to withdraw amount of funds
    function withdrawAmount(uint256 _amount) public onlyOwner {

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to withdraw tokens");
    }

    //    GET All names owned on the contract
    function getAllNames() public view returns (string[] memory) {
        string[] memory allNames = new string[](_tokenIdCounter.current());
        for (uint256 i = 0; i < _tokenIdCounter.current(); i++) {
            allNames[i] = names[i];
        }

        return allNames;
    }


    //    check if the name is valid
    function valid(string calldata name) public pure returns (bool) {
        return bytes(name).length >= 3 && bytes(name).length < 10;
    }

    function price() public pure returns (uint256) {
        return 1 ether;
    }

    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    function setRecord(string memory name, string memory record) public {
        require(msg.sender == domains[name], "Unauthorized");
        records[name] = record;
    }

    function getRecord(string calldata name)
        public
        view
        returns (string memory)
    {
        return records[name];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

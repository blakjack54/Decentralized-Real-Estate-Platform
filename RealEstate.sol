// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstate {
    struct Property {
        address owner;
        string location;
        uint256 price;
        bool forSale;
    }

    uint256 public propertyCount;
    mapping(uint256 => Property) public properties;

    event PropertyListed(uint256 propertyId, address owner, string location, uint256 price);
    event PropertySold(uint256 propertyId, address newOwner, uint256 price);

    function listProperty(string memory location, uint256 price) external {
        propertyCount++;
        properties[propertyCount] = Property(msg.sender, location, price, true);
        emit PropertyListed(propertyCount, msg.sender, location, price);
    }

    function buyProperty(uint256 propertyId) external payable {
        Property storage property = properties[propertyId];
        require(property.forSale, "Property not for sale");
        require(msg.value == property.price, "Incorrect price");

        property.forSale = false;
        payable(property.owner).transfer(msg.value);
        property.owner = msg.sender;

        emit PropertySold(propertyId, msg.sender, property.price);
    }

    function getProperty(uint256 propertyId) external view returns (address owner, string memory location, uint256 price, bool forSale) {
        Property storage property = properties[propertyId];
        return (property.owner, property.location, property.price, property.forSale);
    }
}

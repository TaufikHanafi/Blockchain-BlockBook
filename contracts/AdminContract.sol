// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AdminContract {
    struct Admin {
        bytes32 signature;
    }

    uint private adminCount = 0;
    Admin[] private admins;

    event AdminAdded(uint index);

    function addAdmin(string memory _password) public {
        bytes32 _signature = bytes32(sha256(abi.encodePacked(_password)));
        admins.push(Admin(_signature));
        adminCount++;
        emit AdminAdded(adminCount - 1);
    }

    function checkAdmin(string memory _password) public view returns (bool) {
        bytes32 _signature = bytes32(sha256(abi.encodePacked(_password)));
        for (uint i = 0; i < adminCount; i++) {
            if (admins[i].signature == _signature) {
                return true;
            }
        }
        return false;
    }
}
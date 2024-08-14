// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BookContract.sol";
import "./BookTransactionContract.sol";

contract UserContract {

    BookContract public bookContract;
    BookTransactionContract public bookTransactionContract;

    function setBookContract(address _bookContractAddress) public {
        bookContract = BookContract(_bookContractAddress);
    }

    function setBookTransactionContract(address _bookTransactionContractAddress) public {
        bookTransactionContract = BookTransactionContract(_bookTransactionContractAddress);
    }

    struct User {
        uint index;
        string name;
        string email;
        bytes32 acceshHash; 
    }

    User[] private users;
    uint private userCount = 0;

    event UserAdded(uint index);

    function addUser(string memory _name, string memory _email, string memory _accessKey) public {
        bytes32 _accesHash = bytes32(sha256(abi.encodePacked(_accessKey)));
        users.push(User(userCount, _name, _email, _accesHash));
        userCount++;
        emit UserAdded(userCount - 1);
    }

    function getAllUsers() public view returns (User[] memory) {
        User[] memory result = new User[](userCount);
        for (uint i = 0; i < userCount; i++) {
            result[i] = users[i];
        }
        return result;
    }

    function getUser(uint _index) public view returns (User memory) {
        require (_index < userCount, "User not found");
        return users[_index];
    }

    function editUser(uint _index, string memory _name, string memory _email, string memory _accessKey) public {
        bytes32 _accesHash = bytes32(sha256(abi.encodePacked(_accessKey)));
        require(_accesHash == _accesHash, "Invalid access key");
        require(_index < userCount, "User not found");
        users[_index] = User(_index, _name, _email, _accesHash);
    }

    function getUserTransactions(uint _index) public view returns (BookTransactionContract.Transaction[] memory) {
        require(_index < userCount, "User not found");
        return bookTransactionContract.getTransactionsByUser(_index);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BookContract.sol";
import "./BookTransactionContract.sol";
 
contract WriterContract {
    BookContract public bookContract;
    BookTransactionContract public bookTransactionContract;

    function setBookContract(address _bookContractAddress) public {
        bookContract = BookContract(_bookContractAddress);
    }

    function setBookTransactionContract(address _bookTransactionContractAddress) public {
        bookTransactionContract = BookTransactionContract(_bookTransactionContractAddress);
    }
    struct Writer {
        uint index;
        string name;
        string email;
        bytes32 accesHash;
    }

    Writer[] private writers;
    uint private writerCount = 0;

    event WriterAdded(uint index);

    function addWriter(string memory _name, string memory _email, string memory _accessKey) public {
        bytes32 _accesHash = bytes32(sha256(abi.encodePacked(_accessKey)));
        writers.push(Writer(writerCount, _name, _email, _accesHash));
        writerCount++;
        emit WriterAdded(writerCount - 1);
    }

    function getAllWriters() public view returns (Writer[] memory) {
        Writer[] memory result = new Writer[](writerCount);
        for (uint i = 0; i < writerCount; i++) {
            result[i] = writers[i];
        }
        return result;
    }

    function getWriter(uint _index) public view returns (Writer memory) {
        require(_index < writerCount, "writer not found");
        return writers[_index];
    }

    function getWriterTransactions(uint _index) public view returns (BookTransactionContract.Transaction[] memory) {
        require(_index < writerCount, "writer not found");
        return bookTransactionContract.getTransactionsByWriter(_index);
    }


}


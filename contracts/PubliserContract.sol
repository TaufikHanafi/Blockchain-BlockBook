// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BookContract.sol";
import "./BookTransactionContract.sol";
 
contract PubliserContract {
    BookContract public bookContract;
    BookTransactionContract public bookTransactionContract;

    function setBookContract(address _bookContractAddress) public {
        bookContract = BookContract(_bookContractAddress);
    }

    function setBookTransactionContract(address _bookTransactionContractAddress) public {
        bookTransactionContract = BookTransactionContract(_bookTransactionContractAddress);
    }
    struct Publiser {
        uint index;
        string name;
        string email;
        string Identitas;
        uint bankId;
        bytes32 accesHash;
    }

    Publiser[] private publisers;
    uint private publiserCount = 0;

    event PubliserAdded(uint index);

    function addPubliser(string memory _name, string memory _email, string memory _Identitas,uint _bankId, string memory _accessKey) public {
        bytes32 _accesHash = bytes32(sha256(abi.encodePacked(_accessKey)));
        publisers.push(Publiser(publiserCount, _name, _email, _Identitas, _bankId, _accesHash));
        publiserCount++;
        emit PubliserAdded(publiserCount - 1);
    }

    function getAllPublisers() public view returns (Publiser[] memory) {
        Publiser[] memory result = new Publiser[](publiserCount);
        for (uint i = 0; i < publiserCount; i++) {
            result[i] = publisers[i];
        }
        return result;
    }

    function getPubliser(uint _index) public view returns (Publiser memory) {
        require(_index < publiserCount, "Publiser not found");
        return publisers[_index];
    }

    function editPubliser(uint _index, string memory _name, string memory _email, string memory _identitas, uint _bankId, string memory _accessKey) public {
        bytes32 _accesHash = bytes32(sha256(abi.encodePacked(_accessKey)));
        require(_accesHash == _accesHash, "Invalid access key");
        require(_index < publiserCount, "Publiser not found");
        publisers[_index] = Publiser(_index, _name, _email, _identitas, _bankId , _accesHash);
    }

        function getPubliserTransactions(uint _index) public view returns (BookTransactionContract.Transaction[] memory) {
        require(_index < publiserCount, "publiser not found");
        return bookTransactionContract.getTransactionsByPubliser(_index);
    }
}
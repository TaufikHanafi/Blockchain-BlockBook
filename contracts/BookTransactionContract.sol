// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./PubliserContract.sol";
import "./WriterContract.sol";
import "./UserContract.sol";
import "./BookContract.sol";

contract BookTransactionContract {

    PubliserContract public publiserContract;
    WriterContract public writerContract;
    UserContract public userContract;
    BookContract public bookContract;

    constructor(address _publiserContractAddress, address _writerContractAddress, address _userContractAddress, address _bookContractAddress) {
        publiserContract = PubliserContract(_publiserContractAddress);
        writerContract = WriterContract(_writerContractAddress);
        userContract = UserContract(_userContractAddress);
        bookContract = BookContract(_bookContractAddress);
    }

    struct Transaction {
        uint index;
        uint userId;
        uint publiserId;
        uint bookId;
        uint writerId;
        string gambarBuku;
        string title;
        uint quantity;
        uint256 total; // ditambah 20%
        string ebookUrl;
        string pdfUrl;
        string writer;
    }

    Transaction[] public transactions;
    uint private transactionsCount = 0;

    event TransactionAdded(uint256 index);

    function addTransaction(
        uint _userId,
        uint _publiserId,
        uint _bookId,
        uint _writerId,
        string memory _gambarBuku,
        string memory _title,
        uint _quantity,
        uint256 _total,
        string memory _ebookUrl,
        string memory _pdfUrl,
        string memory _writer
    ) public {
        transactions.push(Transaction(
        transactionsCount,
        _userId,
        _publiserId,
        _bookId,
        _writerId,
        _gambarBuku,
        _title,
        _quantity,
        _total,
        _ebookUrl,
        _pdfUrl,
        _writer
         ));
        transactionsCount++;
        emit TransactionAdded(transactionsCount - 1);
    }

    function setTotal(uint _transactionId, uint256 _total) public {
        require(_transactionId < transactions.length, "Transaction does not exist.");
        transactions[_transactionId].total = _total;
    }

    function getTransaction(uint _transactionId) public view returns (Transaction memory) {
        require(_transactionId < transactions.length, "Transaction does not exist.");
        return transactions[_transactionId];
    }

    function getAllTransactions() public view returns (Transaction[] memory) {
        return transactions;
    }

    function getTransactionByIndex(uint _index) public view returns (Transaction memory) {
        require(_index < transactions.length, "Transaction does not exist.");
        return transactions[_index];
    }

    function getTransactionByAdmin(uint _adminId) public view returns (Transaction[] memory) {
        uint count = 0;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i].userId == _adminId) {
                count++;
            }
        }

        Transaction[] memory result = new Transaction[](count);
        uint j = 0;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i].userId == _adminId) {
                result[j] = transactions[i];
                j++;
            }
        }
        
        return result;
    }

    function getTransactionByBook (uint _bookId) public view returns (Transaction[] memory) {
        uint count = 0;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i].bookId == _bookId) {
                count++;
            }
        }

        Transaction[] memory result = new Transaction[](count);
        uint j = 0;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i].bookId == _bookId) {
                result[j] = transactions[i];
                j++;
            }
        }
        
        return result;
    }

    function getTransactionsByUser(uint _userId) public view returns (Transaction[] memory) {
        uint count = 0;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i].userId == _userId) {
                count++;
            }
        }

        Transaction[] memory result = new Transaction[](count);
        uint j = 0;
        for (uint i = 0; i < transactions.length; i++) {
            if (transactions[i].userId == _userId) {
                result[j] = transactions[i];
                j++;
            }
        }
        
        return result;
    }

    function getTransactionsByPubliser(uint _publiserId) public view returns (Transaction[] memory) {
        uint count = 0;
    for (uint i = 0; i < transactions.length; i++) {
        if (transactions[i].publiserId == _publiserId) {
            count++;
        }
    }

    Transaction[] memory result = new Transaction[](count);
    uint j = 0;
    for (uint i = 0; i < transactions.length; i++) {
        if (transactions[i].publiserId == _publiserId) {
            result[j] = transactions[i];
            j++;
        }
    }
    
    return result;

    }

    function getTransactionsByWriter(uint _writerId) public view returns (Transaction[] memory) {
        uint count = 0;
    for (uint i = 0; i < transactions.length; i++) {
        if (transactions[i].writerId == _writerId) {
            count++;
        }
    }

    Transaction[] memory result = new Transaction[](count);
    uint j = 0;
    for (uint i = 0; i < transactions.length; i++) {
        if (transactions[i].writerId == _writerId) {
            result[j] = transactions[i];
            j++;
        }
    }
    
    return result;

    }

}
// if (transactions[i].userId == _publiserId) {
                // result[i] = transactions[i];
                // j++;
            // }

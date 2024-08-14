// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BookContract.sol";

contract BookTransactionDetailContract {
    BookContract public bookContract;

    constructor(address _bookContractAddress) {
        bookContract = BookContract(_bookContractAddress);
    }

    struct TransactionDetail {
        uint index;
        uint transactionId;
        uint bookId;
        uint quantity;
        uint256 total;
    }

    TransactionDetail[] private details;
    uint private transactionDetailsCount = 0;

    event TransactionDetailAdded(uint index);

    function addTransactionDetail(uint _transactionId, uint _bookId, uint _quantity) public {
        uint256 bookPrice = bookContract.getBookPrice(_bookId);

        details.push(TransactionDetail(transactionDetailsCount,_transactionId, _bookId, _quantity, bookPrice * _quantity));
        transactionDetailsCount++;

        emit TransactionDetailAdded(transactionDetailsCount - 1);
    }

    function getTransactionDetails() public view returns (TransactionDetail[] memory) {
        return details;
    }

    function getTransactionDetail(uint _index) public view returns (TransactionDetail memory) {
        return details[_index];
    }

    function getTransactionDetailsByBook(uint _bookId) public view returns (TransactionDetail[] memory) {
        uint count = 0;
        for (uint i = 0; i < details.length; i++) {
            if (details[i].bookId == _bookId) {
                count++;
            }
        }

        TransactionDetail[] memory result = new TransactionDetail[](count);
        for (uint i = 0; i < details.length; i++) {
            if (details[i].bookId == _bookId) {
                result[i] = details[i];
            }
        }

        return result;
    }

    function getTransactionDetailsByTransaction(uint _transactionId) public view returns (TransactionDetail[] memory) {
        uint count = 0;
        for (uint i = 0; i < details.length; i++) {
            if (details[i].transactionId == _transactionId) {
                count++;
            }
        }

        TransactionDetail[] memory result = new TransactionDetail[](count);
        for (uint i = 0; i < details.length; i++) {
            if (details[i].transactionId == _transactionId) {
                result[i] = details[i];
            }
        }
        return result;
    }

    function getTransactionDetailsByPubliser(uint _publiserId) public view returns (TransactionDetail[] memory) {
        uint count = 0;
        for (uint i = 0; i < details.length; i++) {
            if (bookContract.getBookByIndex(details[i].bookId).publiserId == _publiserId) {
                count++;
            }
        }

        TransactionDetail[] memory result = new TransactionDetail[](count);
        for (uint i = 0; i < details.length; i++) {
            if (bookContract.getBookByIndex(details[i].bookId).publiserId == _publiserId) {
                result[i] = details[i];
            }
        }
        return result;
    }
}
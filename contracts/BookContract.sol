// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./PubliserContract.sol";
import "./WriterContract.sol";
import "./AdminContract.sol";
import "./UserContract.sol";
import "./BookTransactionContract.sol";

contract BookContract {

    PubliserContract private publiserContract;
    WriterContract private writerContract;
    AdminContract private adminContract;
    UserContract private userContract;
    BookTransactionContract private bookTransactionContract;

    constructor(address _publiserContractAddress, address _writerContractAddress , address _adminContractAddress, address _userContractAddress) {
        publiserContract = PubliserContract(_publiserContractAddress);
        writerContract = WriterContract(_writerContractAddress);
        adminContract = AdminContract(_adminContractAddress);
        userContract = UserContract(_userContractAddress);
    }

    function setBookTransactionContract(address _bookTransactionAddress) public {
        bookTransactionContract = BookTransactionContract(_bookTransactionAddress);
    }

    struct Book {
        uint index;
        string title;
        uint publiserId; // publiser index
        uint writerId; // writer index
        string pdfChecksum;  
        uint256 harga;
        string gambarBuku;
        string ebook;
        string bahasa;
        uint jumlahHalaman;
        uint256 waktuPublish; 
        bool visible;
        bool deleted;
    }

    struct BookWithRelations {
        Book book;
        PubliserContract.Publiser publiser;
        WriterContract.Writer writer;
        BookTransactionContract.Transaction[] transaction;
    }

    struct BookVisible {
        Book book;
        PubliserContract.Publiser publiser;
        WriterContract.Writer writer;
        BookTransactionContract.Transaction[] transaction;
    }

    Book[] private books;
    uint private bookCount = 0;

    event BookAdded(uint index);

    function addBook(
        string memory _title,
        uint _publiserId,
        uint _writerId,
        string memory _pdfChecksum,
        uint256 _harga,
        string memory _gambarBuku,
        string memory _ebook,
        string memory _bahasa,
        uint _jmlHalaman
    ) public {
        uint256 _waktuPublish = block.timestamp; 
        books.push(Book(
            bookCount,
            _title, 
            _publiserId, 
            _writerId, 
            _pdfChecksum, 
            _harga, 
            _gambarBuku, 
            _ebook, 
            _bahasa, 
            _jmlHalaman,
            _waktuPublish, 
            false, 
            false
        ));
        bookCount++;
        emit BookAdded(bookCount - 1);
    }

    function setVisible(uint _index, bool _visible, string memory _password) public {
        require(_index < bookCount, "Book does not exist");
        require(adminContract.checkAdmin(_password), "Invalid password");
        books[_index].visible = _visible;
    }

    function deleteBook(uint _index, string memory _password) public {
        require(_index < bookCount, "Book does not exist");
        require(adminContract.checkAdmin(_password), "Invalid password");
        books[_index].deleted = true;
    }

    function getAllBooksWithRelation() public view returns (BookWithRelations[] memory) {
        uint count = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false){
                count++;
            }
        }

        BookWithRelations[] memory result = new BookWithRelations[](count);
        uint j = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false){
                result[j] = BookWithRelations(
                    books[i], 
                    publiserContract.getPubliser(books[i].publiserId),
                    writerContract.getWriter(books[i].writerId), 
                    bookTransactionContract.getTransactionByBook(books[i].index)
                );
                j++;
            }
        }

        return result;
    }

    function getAllBooks() public view returns (Book[] memory) {
        uint count = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false){
                count++;
            }
        }

        Book[] memory result = new Book[](count);
        uint j = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false){
                result[j] = books[i];
                j++;
            }
        }
        return result;
    }

    function getAllVisibleBooks() public view returns (BookVisible[] memory) {
        uint count = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false && books[i].visible == true){
                count++;
            }
        }

        BookVisible[] memory result = new BookVisible[](count);
        uint j = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false && books[i].visible == true){
                result[j] = BookVisible(
                    books[i], 
                    publiserContract.getPubliser(books[i].publiserId),
                    writerContract.getWriter(books[i].writerId), 
                    bookTransactionContract.getTransactionByBook(books[i].index)
                );
                j++;
            }
        }
        return result;
    }

    function getAllNonVisibleBooks() public view returns (Book[] memory) {
        uint count = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false && books[i].visible == false){
                count++;
            }
        }

        Book[] memory result = new Book[](count);
        uint j = 0;
        for (uint i = 0; i < books.length; i++) {
            if(books[i].deleted == false && books[i].visible == false){
                result[j] = books[i];
                j++;
            }
        }
        return result;
    }

    function getAllBooksByPublisher(uint _publiserId) public view returns (Book[] memory) {
        uint count = 0;
        for (uint i = 0; i < books.length; i++) {
            if (books[i].deleted == false && books[i].publiserId == _publiserId) {
                count++;
            }
        }

        Book[] memory result = new Book[](count);
        uint j = 0;
        for (uint i = 0; i < books.length; i++) {
            if (books[i].publiserId == _publiserId) {
                result[j] = books[i];
                j++;
            }
        }
        
        return result;
    }

    function getBookByIndex(uint _index) public view returns (Book memory) {
        require(_index < bookCount, "Book does not exist");
        require(books[_index].deleted == false, "Book does not exist");
        return books[_index];
    }

    function getBookChecksum(uint _index) public view returns (string memory) {
        require(_index < bookCount, "Book does not exist");
        require(books[_index].deleted == false, "Book does not exist");
        Book memory book = books[_index];
        return book.pdfChecksum;
    }

    function getBookPrice(uint _index) public view returns (uint256) {
        require(_index < bookCount, "Book does not exist");
        require(books[_index].deleted == false, "Book does not exist");
        Book memory book = books[_index];
        return book.harga;
    }

    function getBookPublisher(uint _index) public view returns (PubliserContract.Publiser memory) {
        require(_index < bookCount, "Book does not exist");
        require(books[_index].deleted == false, "Book does not exist");
        Book memory book = books[_index];
        return publiserContract.getPubliser(book.publiserId);
    }

    function getBookWriter(uint _index) public view returns (WriterContract.Writer memory) {
        require(_index < bookCount, "Book does not exist");
        require(books[_index].deleted == false, "Book does not exist");
        Book memory book = books[_index];
        return writerContract.getWriter(book.writerId);
    }
}
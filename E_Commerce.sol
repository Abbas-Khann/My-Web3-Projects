// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 < 0.9.0;

contract E_Commerce{
    
    uint public ID = 0;

    // Create products
    struct Product {
        string description;
        string imageURL;
        string author;
        string title;
        uint price;
        uint id;
    }

    Product[] public products;

    mapping (address => uint[]) public cart;

    function addProduct(string memory _description,
    string memory _imageURL,
    string memory _author,
    string memory _title,
    uint _price
    ) public {

    Product memory tempProduct = Product({
        description : _description,
        imageURL : _imageURL,
        author : _author,
        title : _title,
        price : _price,
        id : ID
    });

    products.push(tempProduct);
     ID = ID + 1;
    }  


    // Add carts
    function addItemsToCart(uint _productId) public {
        cart[msg.sender].push(_productId);
    }

    function getItemFromCart() public view returns(uint[] memory) {
        return cart[msg.sender];
    }

    function Checkout() public view returns (uint) {
        uint cartTotal;
        // We need to loop through to get all the cart items
        uint[] memory cartItems = getItemFromCart();
        for(uint i = 0; i < cartItems.length; i++){
            uint productId = cartItems[i];
            uint price = products[productId].price;
            cartTotal += price;

        }
        return cartTotal;

    }

}

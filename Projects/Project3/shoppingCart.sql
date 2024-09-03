-- Create Products Table
CREATE TABLE Products (
    ProductId SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Create Cart Table
CREATE TABLE Cart (
    ProductId INT PRIMARY KEY REFERENCES Products(ProductId),
    Qty INT NOT NULL CHECK (Qty > 0)
);

-- Create Users Table
CREATE TABLE Users (
    User_ID SERIAL PRIMARY KEY,
    Username VARCHAR(100) NOT NULL
);

-- Create OrderHeader Table
CREATE TABLE OrderHeader (
    OrderID SERIAL PRIMARY KEY,
    User_ID INT REFERENCES Users(User_ID),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    OrderID INT REFERENCES OrderHeader(OrderID),
    ProdID INT REFERENCES Products(ProductId),
    Qty INT NOT NULL CHECK (Qty > 0),
    PRIMARY KEY (OrderID, ProdID)
);

INSERT INTO Users (Username) VALUES 
('Arnold'),
('Sheryl');

-- Insert Coke into the Products table
INSERT INTO Products (name, price) VALUES ('Coke', 10.00);

-- Insert Chips into the Products table
INSERT INTO Products (name, price) VALUES ('Chips', 5.00);


-- Add Coke to the cart (ProductId = 1)
INSERT INTO Cart (ProductId, Qty)
VALUES (1, 1)
ON CONFLICT (ProductId)
DO UPDATE SET Qty = Cart.Qty + 1;

-- Add Chips to the cart (ProductId = 2)
INSERT INTO Cart (ProductId, Qty)
VALUES (2, 1)
ON CONFLICT (ProductId)
DO UPDATE SET Qty = Cart.Qty + 1;

-- Remove one Coke from the cart (ProductId = 1)
WITH updated AS (
    UPDATE Cart
    SET Qty = Qty - 1
    WHERE ProductId = 1 AND Qty > 1
    RETURNING *
)
DELETE FROM Cart
WHERE ProductId = 1 AND NOT EXISTS (SELECT 1 FROM updated);

-- Checkout for User 1
WITH new_order AS (
    INSERT INTO OrderHeader (User_ID)
    VALUES (1)
    RETURNING OrderID
)
INSERT INTO OrderDetails (OrderID, ProdID, Qty)
SELECT new_order.OrderID, Cart.ProductId, Cart.Qty
FROM Cart, new_order;

-- Clear the cart after checkout
DELETE FROM Cart;

-- Checkout for User 1
WITH new_order AS (
    INSERT INTO OrderHeader (User_ID)
    VALUES (1)
    RETURNING OrderID
)
INSERT INTO OrderDetails (OrderID, ProdID, Qty)
SELECT new_order.OrderID, Cart.ProductId, Cart.Qty
FROM Cart, new_order;

-- Clear the cart after checkout
DELETE FROM Cart;

-- Remove one Coke from the cart (ProductId = 1)
WITH updated AS (
    UPDATE Cart
    SET Qty = Qty - 1
    WHERE ProductId = 1 AND Qty > 1
    RETURNING *
)
DELETE FROM Cart
WHERE ProductId = 1 AND NOT EXISTS (SELECT 1 FROM updated);

-- Verify the cart contents
SELECT * FROM Cart;

-- Checkout for User 1
WITH new_order AS (
    INSERT INTO OrderHeader (User_ID)
    VALUES (1)
    RETURNING OrderID
)
INSERT INTO OrderDetails (OrderID, ProdID, Qty)
SELECT new_order.OrderID, Cart.ProductId, Cart.Qty
FROM Cart, new_order;

-- Verify the OrderHeader and OrderDetails
SELECT * FROM OrderHeader;
SELECT * FROM OrderDetails;

-- Clear the cart after checkout
DELETE FROM Cart;

SELECT oh.OrderID, u.Username, p.name, od.Qty
FROM OrderDetails od
JOIN OrderHeader oh ON od.OrderID = oh.OrderID
JOIN Users u ON oh.User_ID = u.User_ID
JOIN Products p ON od.ProdID = p.ProductId
WHERE oh.OrderID = 1;


SELECT oh.OrderID, u.Username, p.name, od.Qty
FROM OrderDetails od
JOIN OrderHeader oh ON od.OrderID = oh.OrderID
JOIN Users u ON oh.User_ID = u.User_ID
JOIN Products p ON od.ProdID = p.ProductId
WHERE DATE(oh.OrderDate) = '2024-09-03';

CREATE OR REPLACE FUNCTION add_to_cart(product_id INT) RETURNS VOID AS $$
BEGIN
    INSERT INTO Cart (ProductId, Qty)
    VALUES (product_id, 1)
    ON CONFLICT (ProductId)
    DO UPDATE SET Qty = Cart.Qty + 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION remove_from_cart(product_id INT) RETURNS VOID AS $$
BEGIN
    WITH updated AS (
        UPDATE Cart
        SET Qty = Qty - 1
        WHERE ProductId = product_id AND Qty > 1
        RETURNING *
    )
    DELETE FROM Cart
    WHERE ProductId = product_id AND NOT EXISTS (SELECT 1 FROM updated);
END;
$$ LANGUAGE plpgsql;

--joined

SELECT 
    oh.OrderID,
    u.Username,
    oh.OrderDate,
    p.name AS ProductName,
    od.Qty AS Quantity,
    p.price AS Price,
    (od.Qty * p.price) AS TotalPrice
FROM 
    OrderDetails od
JOIN 
    OrderHeader oh ON od.OrderID = oh.OrderID
JOIN 
    Users u ON oh.User_ID = u.User_ID
JOIN 
    Products p ON od.ProdID = p.ProductId
ORDER BY 
    oh.OrderID;
/* =========================================================
   DATABASE CREATION
   Creates the main database for the e-commerce project
========================================================= */

CREATE DATABASE ecommerce;
USE ecommerce;


/* =========================================================
   CATEGORY TABLE
   Stores product category master data
========================================================= */

CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);


/* =========================================================
   PRODUCT TABLE
   Stores product-level details including pricing and cost
   Each product belongs to one category
========================================================= */

CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);


/* =========================================================
   SELLER TABLE
   Stores seller information
========================================================= */

CREATE TABLE seller (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(200) NOT NULL,
    origin VARCHAR(100) NOT NULL
);


/* =========================================================
   CUSTOMER TABLE
   Stores customer demographic information
========================================================= */

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);


/* =========================================================
   ORDERS TABLE
   Central transactional table
   Links customers and sellers
========================================================= */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    seller_id INT NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    CONSTRAINT fk_orders_seller
        FOREIGN KEY (seller_id)
        REFERENCES seller(seller_id)
);


/* =========================================================
   ORDER ITEMS TABLE
   Line-level order details
   Resolves many-to-many between orders and products
========================================================= */

CREATE TABLE orderitems (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_perunit DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orderitems_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_orderitems_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
);


/* =========================================================
   SHIPPING TABLE
   Stores shipment and delivery lifecycle details
========================================================= */

CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_date DATE,
    return_date DATE,
    shipping_provider VARCHAR(100) NOT NULL,
    delivery_status VARCHAR(50) NOT NULL,
    CONSTRAINT fk_shipping_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


/* =========================================================
   PAYMENTS TABLE
   Stores payment transactions related to orders
========================================================= */

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


/* =========================================================
   INVENTORY TABLE
   Tracks product stock across warehouses
========================================================= */

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    stock INT NOT NULL,
    warehouse VARCHAR(100) NOT NULL,
    laststock_date DATE NOT NULL,
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
);


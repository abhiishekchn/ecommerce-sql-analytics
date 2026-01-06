# Data Dictionary  
This document describes the structure and meaning of each table used in the e-commerce SQL analytics project.

---

## category
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| category_id | INT | Unique identifier for each product category |
| category_name | VARCHAR | Name of the product category |

---

## product
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| product_id | INT | Unique identifier for each product |
| product_name | VARCHAR | Name of the product |
| price | DECIMAL | Selling price per unit |
| cogs | DECIMAL | Cost of goods sold per unit |
| category_id | INT | Category to which the product belongs |

---

## seller
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| seller_id | INT | Unique identifier for each seller |
| seller_name | VARCHAR | Seller name |
| origin | VARCHAR | Seller origin location |

---

## customer
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| customer_id | INT | Unique identifier for each customer |
| first_name | VARCHAR | Customer first name |
| last_name | VARCHAR | Customer last name |
| state | VARCHAR | Customer state or region |

---

## orders
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| order_id | INT | Unique identifier for each order |
| order_date | DATE | Date when the order was placed |
| customer_id | INT | Customer who placed the order |
| seller_id | INT | Seller fulfilling the order |
| order_status | VARCHAR | Current status of the order |

---

## orderitems
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| order_item_id | INT | Unique identifier for each order line item |
| order_id | INT | Associated order |
| product_id | INT | Product purchased |
| quantity | INT | Number of units ordered |
| price_perunit | DECIMAL | Price per unit at time of order |

---

## payments
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| payment_id | INT | Unique identifier for each payment |
| order_id | INT | Order associated with the payment |
| payment_date | DATE | Date of payment |
| payment_status | VARCHAR | Status of the payment |

---

## shipping
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| shipping_id | INT | Unique identifier for shipment |
| order_id | INT | Associated order |
| shipping_date | DATE | Date the order was shipped |
| return_date | DATE | Date the order was returned (if applicable) |
| shipping_provider | VARCHAR | Logistics service provider |
| delivery_status | VARCHAR | Delivery status of the order |

---

## inventory
| Column Name | Data Type | Description |
|------------|-----------|-------------|
| inventory_id | INT | Unique identifier for inventory record |
| product_id | INT | Product being tracked |
| stock | INT | Current stock level |
| warehouse | VARCHAR | Warehouse location |
| laststock_date | DATE | Last stock update date |


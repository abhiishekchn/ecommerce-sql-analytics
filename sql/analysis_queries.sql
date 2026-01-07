/* =====================================================
   BUSINESS PROBLEM ANALYSIS
   Global E-commerce SQL Analytics
===================================================== */


/* =====================================================
   1. TOP SELLING PRODUCTS
   Top 10 products by total sales value
===================================================== */

SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.quantity * oi.price_perunit), 2) AS total_sales_amount
FROM product p
JOIN orderitems oi 
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sales_amount DESC
LIMIT 10;


/* =====================================================
   2. REVENUE BY CATEGORY
   Total revenue and percentage contribution by category
===================================================== */

SELECT 
    c.category_id,
    c.category_name,
    ROUND(SUM(oi.quantity * oi.price_perunit), 2) AS category_revenue,
    ROUND(
        SUM(oi.quantity * oi.price_perunit) * 100 /
        (SELECT SUM(quantity * price_perunit) FROM orderitems),
        2
    ) AS revenue_contribution_pct
FROM category c
JOIN product p 
    ON c.category_id = p.category_id
JOIN orderitems oi 
    ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY category_revenue DESC;


/* =====================================================
   3. AVERAGE ORDER VALUE (AOV)
   Customers with more than 5 orders
===================================================== */

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    ROUND(SUM(oi.quantity * oi.price_perunit) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM customer c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN orderitems oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, full_name
HAVING COUNT(DISTINCT o.order_id) > 5
ORDER BY avg_order_value DESC;


/* =====================================================
   4. MONTHLY SALES TREND (2024)
   Current month vs previous month sales
===================================================== */

SELECT 
    MONTH(o.order_date) AS month_no,
    ROUND(SUM(oi.quantity * oi.price_perunit), 2) AS current_month_sales,
    LAG(ROUND(SUM(oi.quantity * oi.price_perunit), 2))
        OVER (ORDER BY MONTH(o.order_date)) AS previous_month_sales
FROM orders o
JOIN orderitems oi 
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2024
GROUP BY MONTH(o.order_date)
ORDER BY month_no;


/* =====================================================
   5. CUSTOMERS WITH NO PURCHASE
===================================================== */

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.state
FROM customer c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


/* =====================================================
   6. BEST SELLING CATEGORY BY STATE
===================================================== */

WITH category_sales AS (
    SELECT 
        c.state,
        ct.category_name,
        ROUND(SUM(oi.quantity * oi.price_perunit), 2) AS total_sales,
        RANK() OVER (
            PARTITION BY c.state 
            ORDER BY SUM(oi.quantity * oi.price_perunit) DESC
        ) AS sales_rank
    FROM customer c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    JOIN orderitems oi 
        ON o.order_id = oi.order_id
    JOIN product p 
        ON oi.product_id = p.product_id
    JOIN category ct 
        ON p.category_id = ct.category_id
    GROUP BY c.state, ct.category_name
)
SELECT 
    state,
    category_name AS best_selling_category,
    total_sales
FROM category_sales
WHERE sales_rank = 1;


/* =====================================================
   7. CUSTOMER LIFETIME VALUE (CLTV)
===================================================== */

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    ROUND(SUM(oi.quantity * oi.price_perunit), 2) AS customer_lifetime_value,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.price_perunit) DESC
    ) AS cltv_rank
FROM customer c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN orderitems oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, full_name;


/* =====================================================
   8. INVENTORY STOCK ALERT
===================================================== */

SELECT 
    i.product_id,
    p.product_name,
    i.stock,
    i.warehouse,
    i.laststock_date
FROM inventory i
JOIN product p 
    ON i.product_id = p.product_id
WHERE i.stock < 20
ORDER BY i.stock ASC;


/* =====================================================
   9. SHIPPING DELAYS (> 5 DAYS)
===================================================== */

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    o.order_id,
    o.order_date,
    s.shipping_date,
    s.shipping_provider
FROM orders o
JOIN customer c 
    ON o.customer_id = c.customer_id
JOIN shipping s 
    ON o.order_id = s.order_id
WHERE s.shipping_date > o.order_date + INTERVAL 5 DAY;


/* =====================================================
   10. PAYMENT STATUS DISTRIBUTION
===================================================== */

SELECT 
    payment_status,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM payments), 2) AS payment_percentage
FROM payments
GROUP BY payment_status;


/* =====================================================
   11. TOP PERFORMING SELLERS
===================================================== */

SELECT 
    s.seller_id,
    s.seller_name,
    ROUND(SUM(oi.quantity * oi.price_perunit), 2) AS total_sales,
    SUM(CASE 
        WHEN o.order_status IN ('Delivered','Shipped','Pending') THEN 1 
        ELSE 0 
    END) AS successful_orders,
    SUM(CASE 
        WHEN o.order_status IN ('Cancelled','Returned') THEN 1 
        ELSE 0 
    END) AS failed_orders
FROM seller s
JOIN orders o 
    ON s.seller_id = o.seller_id
JOIN orderitems oi 
    ON o.order_id = oi.order_id
GROUP BY s.seller_id, s.seller_name
ORDER BY total_sales DESC
LIMIT 5;


/* =====================================================
   12. PRODUCT PROFIT MARGIN
===================================================== */

SELECT 
    p.product_id,
    p.product_name,
    ROUND(SUM((oi.quantity * oi.price_perunit) - (p.cogs * oi.quantity)), 2) AS profit,
    ROUND(
        SUM((oi.quantity * oi.price_perunit) - (p.cogs * oi.quantity)) * 100 /
        SUM(p.cogs * oi.quantity),
        2
    ) AS profit_margin_pct,
    RANK() OVER (
        ORDER BY 
        SUM((oi.quantity * oi.price_perunit) - (p.cogs * oi.quantity)) DESC
    ) AS profit_rank
FROM product p
JOIN orderitems oi 
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;


/* =====================================================
   13. MOST RETURNED PRODUCTS
===================================================== */

SELECT 
    p.product_id,
    p.product_name,
    SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) AS return_count,
    ROUND(
        SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) * 100 /
        COUNT(*),
        2
    ) AS return_rate_pct
FROM orders o
JOIN orderitems oi 
    ON o.order_id = oi.order_id
JOIN product p 
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY return_rate_pct DESC;


/* =====================================================
   14. CUSTOMER RETURN BEHAVIOR
===================================================== */

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) AS total_returns,
    CASE 
        WHEN SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) > 3 
        THEN 'High Return'
        ELSE 'Normal'
    END AS customer_category
FROM customer c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, full_name
ORDER BY total_returns DESC;


/* =====================================================
   15. IDENTIFYING CUSTOMER AS RETURNING OR NEW
===================================================== */

WITH Cte1 AS (
    SELECT 
        c.customer_id AS customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS full_name,
        COUNT(o.order_id) AS total_order,
        SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_order
    FROM customer AS c
    JOIN orders AS o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_id
    ORDER BY returned_order DESC
)
SELECT 
    customer_id,
    full_name,
    total_order,
    returned_order,
    CASE
        WHEN returned_order > 3 THEN 'Returning'
        ELSE 'New'
    END AS cust_category
FROM cte1;


/* =====================================================
   16. TOP 5 CUSTOMERS BY ORDER IN EACH STATE
===================================================== */

SELECT * FROM (
	SELECT
		c.state,
		c.customer_id, 
		CONCAT(c.first_name, ' ', c.last_name) AS full_name,
		COUNT(o.order_id) AS total_order,
		SUM(oi.price_perunit * oi.quantity) AS total_sales,
		DENSE_RANK() OVER(
			PARTITION BY c.state 
			ORDER BY COUNT(o.order_id) DESC
		) AS ordr_rnk
	FROM customer AS c
	JOIN orders AS o
		ON c.customer_id = o.customer_id
	JOIN orderitems AS oi
		ON o.order_id = oi.order_id
	GROUP BY 
		c.state,
		c.customer_id,
		CONCAT(c.first_name, ' ', c.last_name)
) AS t1
WHERE ordr_rnk <= 5;


/* =====================================================
   17. REVENUE BY SHIPPING PROVIDER
===================================================== */

SELECT 
	sh.shipping_provider AS shipping_provider,
	COUNT(o.order_id) AS total_order_handeled,
	SUM(oi.price_perunit * oi.quantity) AS total_sales,
	SUM(
		CASE 
			WHEN sh.delivery_status = 'Delivered' THEN 1 
			ELSE 0 
		END
	) AS delivered_orders,
	ROUND(
		SUM(
			CASE 
				WHEN sh.delivery_status = 'Delivered' THEN 1 
				ELSE 0 
			END
		) * 100 / COUNT(o.order_id), 
		2
	) AS delivery_rate
FROM orders AS o
JOIN orderitems AS oi
	ON o.order_id = oi.order_id
JOIN shipping AS sh
	ON sh.order_id = o.order_id
GROUP BY sh.shipping_provider
ORDER BY total_order_handeled DESC;


/* =====================================================
   19. TOP 10 PRODUCTS WITH HIGHEST DECREASING REVENUE RATIO
===================================================== */

WITH Cte1 AS (
	SELECT 
		p.product_id,
		p.product_name,
		c.category_name,
		SUM(oi.quantity * oi.price_perunit) AS sales_2023
	FROM orders AS o
	JOIN orderitems AS oi
		ON oi.order_id = o.order_id
	JOIN product AS p
		ON oi.product_id = p.product_id
	JOIN category AS c
		ON c.category_id = p.category_id
	WHERE YEAR(o.order_date) = 2023
	GROUP BY p.product_id
),
Cte2 AS (
	SELECT 
		p.product_id,
		p.product_name,
		c.category_name,
		SUM(oi.quantity * oi.price_perunit) AS sales_2024
	FROM orders AS o
	JOIN orderitems AS oi
		ON oi.order_id = o.order_id
	JOIN product AS p
		ON oi.product_id = p.product_id
	JOIN category AS c
		ON c.category_id = p.category_id
	WHERE YEAR(o.order_date) = 2024
	GROUP BY p.product_id
)
SELECT 
	c1.product_id,
	c1.product_name,
	c1.category_name,
	c1.sales_2023,
	c2.sales_2024,
	ROUND(
		(c2.sales_2024 - c1.sales_2023) * 100 / c1.sales_2023,
		2
	) AS dec_rev_rate
FROM Cte1 AS c1
JOIN Cte2 AS c2
	ON c1.product_id = c2.product_id
WHERE c1.sales_2023 > c2.sales_2024
ORDER BY dec_rev_rate DESC
LIMIT 10;


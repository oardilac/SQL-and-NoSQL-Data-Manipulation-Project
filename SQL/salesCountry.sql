DROP PROCEDURE IF EXISTS create_indexes_if_not_exists;

delimiter //
CREATE PROCEDURE create_indexes_if_not_exists()
BEGIN
    -- orders_customerNumber
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE table_schema=DATABASE() AND table_name='orders' AND index_name='idx_orders_customerNumber') = 0 THEN
        CREATE INDEX idx_orders_customerNumber ON orders (customerNumber);
    END IF;

    -- orders_orderNumber
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE table_schema=DATABASE() AND table_name='orders' AND index_name='idx_orders_orderNumber') = 0 THEN
        CREATE INDEX idx_orders_orderNumber ON orders (orderNumber);
    END IF;

    -- customers_country
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE table_schema=DATABASE() AND table_name='customers' AND index_name='idx_customers_country') = 0 THEN
        CREATE INDEX idx_customers_country ON customers (country);
    END IF;

    -- orderdetails_orderNumber
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE table_schema=DATABASE() AND table_name='orderdetails' AND index_name='idx_orderdetails_orderNumber') = 0 THEN
        CREATE INDEX idx_orderdetails_orderNumber ON orderdetails (orderNumber);
    END IF;

    -- orderdetails_productCode
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE table_schema=DATABASE() AND table_name='orderdetails' AND index_name='idx_orderdetails_productCode') = 0 THEN
        CREATE INDEX idx_orderdetails_productCode ON orderdetails (productCode);
    END IF;

    -- products_productCode
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE table_schema=DATABASE() AND table_name='products' AND index_name='idx_products_productCode') = 0 THEN
        CREATE INDEX idx_products_productCode ON products (productCode);
    END IF;

    -- products_productName
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE table_schema=DATABASE() AND table_name='products' AND index_name='idx_products_productName') = 0 THEN
        CREATE INDEX idx_products_productName ON products (productName);
    END IF;
END //
delimiter ;

-- call the stored procedure to create the indexes if they do not exist
CALL create_indexes_if_not_exists();

-- SQL Query
SELECT t1.country, 
       t1.productName, 
       t1.amount,
       CONCAT(ROUND((t1.amount/t1.total_amount) * 100, 2), '%') AS participation_prc
FROM
(
  SELECT c.country, 
         p.productName, 
         SUM(d.quantityOrdered * d.priceEach) AS amount,
         SUM(SUM(d.quantityOrdered*d.priceEach)) OVER(PARTITION BY c.country) AS total_amount,
         RANK() OVER(PARTITION BY c.country ORDER BY SUM(d.quantityOrdered*d.priceEach) DESC) as ranking
  FROM orders o
  INNER JOIN customers c ON o.customerNumber = c.customerNumber
  INNER JOIN orderdetails d ON o.orderNumber = d.orderNumber
  INNER JOIN products p ON d.productCode = p.productCode
  GROUP BY c.country, p.productName
) t1
WHERE t1.ranking = 1
ORDER BY t1.amount DESC;
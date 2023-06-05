delimiter //
CREATE PROCEDURE CreateSalesTable()
BEGIN
 -- check if table already exists and drop it
 DROP TABLE IF EXISTS SalesTable;

 -- create a new table from the query
 CREATE TABLE SalesTable AS
 select
  o.orderDate as OrderDate,
  o.orderNumber as OrderNumber,
  o.requiredDate as RequiredDate,
  o.shippedDate as ShippedDate,
  o.status as Status,
  c.customerNumber as CustomerNumber,
  c.customerName as CustomerName,
  c.phone as Phone,
  c.city as City,
  COALESCE(c.state, c.city) as State,
  c.country as Country,
  d.quantityOrdered as QuantityOrdered,
  d.priceEach as PriceEach,
  d.orderLineNumber as OrderLineNumber,
  p.productCode as ProductCode,
  p.productName as ProductName,
  p.productDescription as ProductDescription,
  p.productVendor as ProductVendor,
  p.buyPrice as BuyPrice,
  (d.quantityOrdered*d.priceEach) as SalesAmount,
  (d.quantityOrdered*p.buyPrice) as CostAmount
 from orders o
  left join customers c on (o.customerNumber = c.customerNumber)
  left join orderdetails d on (d.orderNumber = o.orderNumber)
  left join products p on (p.productCode = d.productCode);

 -- create indexes on the SalesTable
 CREATE INDEX idx_orderNumber ON SalesTable (OrderNumber);
 CREATE INDEX idx_customerNumber ON SalesTable (CustomerNumber);
 CREATE INDEX idx_productCode ON SalesTable (ProductCode);

END//
delimiter ;

-- execute the procedure
CALL CreateSalesTable();

-- view the table
select *
from SalesTable;
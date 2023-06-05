DROP PROCEDURE IF EXISTS get_margin_contribution_by_rank;

delimiter //
CREATE PROCEDURE get_margin_contribution_by_rank(
         IN country_ranking INT, 
         OUT country_name VARCHAR(50), 
         OUT margin_contribution_prc DECIMAL(10, 2), 
         OUT delta_gmc_prc DECIMAL(10, 2)
)
BEGIN
    WITH data AS (
        SELECT
            t.country,
            ROUND(SUM(t.margin) / SUM(t.quantityOrdered * t.priceEach), 2) AS margin_contribution,
            RANK() OVER(ORDER BY SUM(t.margin) / SUM(t.quantityOrdered * t.priceEach) DESC) AS ranking,
            SUM(SUM(t.margin)) OVER() / SUM(SUM(t.quantityOrdered * t.priceEach)) OVER() AS global_margin_contribution
        FROM
            (
                SELECT 
                    o.orderNumber,
                    od.quantityOrdered,
                    od.priceEach,
                    p.productCode,
                    p.buyPrice,
                    c.country,
                    ((od.quantityOrdered * od.priceEach) - (od.quantityOrdered * p.buyPrice)) AS margin
                FROM
                    orders o
                    JOIN orderdetails od ON o.orderNumber = od.orderNumber
                    JOIN products p ON od.productCode = p.productCode
                    JOIN customers c ON o.customerNumber = c.customerNumber
            ) t
        GROUP BY
            t.country
    )
    SELECT
        country,
        margin_contribution,
        margin_contribution - global_margin_contribution AS delta_mc
    INTO
        country_name,
        margin_contribution_prc,
        delta_gmc_prc
    FROM
        data
    WHERE
        ranking = country_ranking;
END //
delimiter ;

CALL get_margin_contribution_by_rank(1, @country, @margin_contribution, @delta_global_margin_contribution);
SELECT
 @country, 
 CONCAT(FORMAT(@margin_contribution*100, 2), '%') AS margin_contribution, 
 CONCAT(FORMAT(@delta_global_margin_contribution*100, 2), '%') AS delta_global_margin_contribution;
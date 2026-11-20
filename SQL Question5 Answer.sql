--5th question. 
--The CRM team wants to size up the customer base by value. Split customers into
--four quartiles by lifetime completed spend, and for each quartile report how many
--customers fall in it and their average spend. Required output: spend_quartile,
--customer_count, avg_lifetime_spend.

--select count(customer_id) from fact_orders

;WITH CustomerSpend AS
(
    SELECT
        customer_id,
        SUM(order_total) AS lifetime_spend
    FROM fact_orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
CustomerQuartile AS
(
    SELECT
        customer_id,
        lifetime_spend,
        NTILE(4) OVER (
            ORDER BY lifetime_spend DESC
        ) AS spend_quartile
    FROM CustomerSpend
)

SELECT
    spend_quartile,
    COUNT(customer_id) AS customer_count,
    CAST(AVG(lifetime_spend) AS DECIMAL(18,2))
        AS avg_lifetime_spend
FROM CustomerQuartile
GROUP BY spend_quartile
ORDER BY spend_quartile;
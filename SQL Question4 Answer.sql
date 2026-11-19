USE Voltkart;
--4. Finance wants the revenue trend with momentum. Produce
--monthly completed revenue with a cumulative running total and the month-over-month %
--change. Required output: order_month (YYYY-MM), monthly_revenue, running_total,
--mom_pct_change.

WITH Monthlyrevenue As 
(
SELECT 
FORMAT(order_date, 'yyyy-MM') as order_month, 
SUM(order_total) as monthly_revenue
FROM fact_orders 
WHERE order_status = 'Completed'
GROUP BY FORMAT(order_date, 'yyyy-MM')
),

RevenueMetrics AS (
SELECT order_month,
       monthly_revenue,

	     SUM(monthly_revenue) OVER (
            ORDER BY order_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total,

        LAG(monthly_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue

    FROM MonthlyRevenue
)
SELECT 
       order_month,
       monthly_revenue,
	   running_total,
    CAST(
        ROUND(
            (monthly_revenue - previous_month_revenue)
            * 100.0 / NULLIF(previous_month_revenue, 0),
            2
        ) AS DECIMAL(10,2)
    ) AS mom_pct_change

FROM RevenueMetrics
ORDER BY order_month;

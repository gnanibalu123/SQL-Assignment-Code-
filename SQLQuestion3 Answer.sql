--Merchandising wants the stars of each category. For every category, return the
--top 3 products by completed revenue. Required output: category_name, product_name,
--total_revenue, revenue_rank.
--Concepts: SUM of line_amount, RANK() OVER (PARTITION BY category ORDER BY
--revenue DESC), then filter to rank ≤ 3.
USE Voltkart
;WITH product_revenue AS (
    SELECT
        dc.category_id,
        dc.category_name,
        dp.product_id,
        dp.product_name,
        SUM(foi.line_amount) AS total_revenue
    FROM fact_order_items foi
    INNER JOIN dim_product  dp ON foi.product_id = dp.product_id
    INNER JOIN dim_category dc ON dc.category_id = dp.category_id
    INNER JOIN fact_orders  fo ON fo.order_id    = foi.order_id
    WHERE fo.order_status = 'Completed'
    GROUP BY dc.category_id, dc.category_name, dp.product_id, dp.product_name
),
ranked AS (
    SELECT
        category_name,
        product_name,
        total_revenue,
        RANK() OVER (
            PARTITION BY category_id
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM product_revenue
)
SELECT category_name, product_name, total_revenue, revenue_rank
FROM ranked
WHERE revenue_rank <= 3
ORDER BY category_name, revenue_rank;
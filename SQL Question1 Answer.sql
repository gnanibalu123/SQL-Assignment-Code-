
USE Voltkart;

--1. Voltkart's commercial team wants a quick look at the biggest sales. Return the
--top 20 completed orders by value, with the customer and the sales rep behind each one.
--Required output: order_id, order_date, customer_name, sales_rep_name, order_total.

SELECT TOP 20 fo.order_id, fo.order_date, dc.customer_name, de.employee_name as sales_rep_name, fo.order_total
FROM fact_orders fo 
INNER JOIN 
dim_customer dc ON fo.customer_id = dc.customer_id
INNER JOIN 
dim_employee de ON de.employee_id = fo.sales_rep_id
where fo.order_status = 'Completed'
order by fo.order_total DESC

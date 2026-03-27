create database project1;
use project1;

select  * from Customer;
select*from Transactions;
select* from prod_cat_info;

-- QN 1
select count(*)as total_rows from Transactions;
select count(*)as total_rows from customer;
select count(*)as total_rows from prod_cat_info;

-- QN 2
select count(*)as total_returns
from Transactions where qty<0;

-- QN 3
select str_to_date(tran_date,'%d_%m_%y')as nw_date
from transactions;

-- QN 4
select 
min(tran_date)as start_date,
max(tran_date)as end_date,
datediff(max(tran_date),min(tran_date))as total_days,
timestampdiff(month,min(tran_date),max(tran_date)) as total_yrs
from transactions;

-- QN 5
select prod_cat from prod_cat_info where prod_subcat='DIY';

-- QN 6
SELECT Store_type, COUNT(*) AS total_transactions
FROM transactions
GROUP BY Store_type
ORDER BY total_transactions DESC
LIMIT 1;

-- QN 7
SELECT Gender, COUNT(*) AS total_customers
FROM customer
GROUP BY Gender;

-- QN 8
SELECT city_code, COUNT(*) AS total_customers
FROM customer
GROUP BY city_code
ORDER BY total_customers DESC
LIMIT 1;

-- QN 9
SELECT COUNT(*) AS total_subcategories
FROM prod_cat_info
WHERE prod_cat = 'Books';

-- QN 10
SELECT MAX(Qty) AS max_quantity_ordered
FROM transactions;

-- QN 11
select p.prod_cat,
sum(t.total_amt)as net_revenue from transactions t
join prod_cat_info p
on t.prod_cat_code=p.prod_cat_code
and t.prod_subcat_code=p.prod_sub_cat_code
where p.prod_cat in('electronics','books')
group by p.prod_cat;

-- QN 12
select cust_id,count(*)as transaction_count from transactions
where qty>0
group by cust_id having count(*)>10;


-- QN 13
select sum(t.total_amt)as combained_revenue from transactions t
join prod_cat_info p
on t.prod_cat_code=p.prod_cat_code
and t.prod_subcat_code=p.prod_sub_cat_code
where p.prod_cat in ('electronics','clothing')
and t.store_type='flagship store';

-- QN 14
SELECT p.prod_subcat,
       SUM(t.total_amt) AS total_revenue
FROM transactions t
JOIN customer c 
  ON t.cust_id = c.customer_Id
JOIN prod_cat_info p 
  ON t.prod_cat_code = p.prod_cat_code
     AND t.prod_subcat_code = p.prod_sub_cat_code
WHERE c.Gender = 'M'
  AND p.prod_cat = 'Electronics'
GROUP BY p.prod_subcat
ORDER BY total_revenue DESC;

-- QN 15
SELECT p.prod_subcat,
    round(SUM(CASE WHEN t.Qty > 0 THEN t.total_amt ELSE 0 END) *100.0/sum(t.total_amt),2)as sales_percentage,
    round(SUM(CASE WHEN t.Qty < 0 THEN t.total_amt ELSE 0 END) *100.0/sum(t.total_amt),2)as return_percentage
   
FROM transactions t
JOIN prod_cat_info p ON t.prod_cat_code = p.prod_cat_code
                   AND t.prod_subcat_code = p.prod_sub_cat_code
GROUP BY p.prod_subcat ORDER BY sum(case when t.qty>0 then t.total_amt else 0 end)
DESC LIMIT 5;

-- QN 16
SELECT SUM(t.total_amt) AS revenue
FROM Transactions t
JOIN Customer c ON t.cust_id = c.customer_Id
WHERE DATEDIFF(MAX(t.tran_date), t.tran_date) <= 30
AND TIMESTAMPDIFF(YEAR, c.DOB, t.tran_date) BETWEEN 25 AND 35;


-- QN 17
SELECT p.prod_cat, SUM(abs(t.total_amt))AS return_value
FROM transactions t
JOIN prod_cat_info p ON t.prod_cat_code = p.prod_cat_code
 AND t.prod_subcat_code = p.prod_sub_cat_code
WHERE t.Qty < 0
  AND t.tran_date >= DATE_SUB((SELECT MAX(tran_date) FROM transactions), INTERVAL 3 MONTH)
GROUP BY p.prod_cat ORDER BY return_value desc  
LIMIT 1;

-- QN 18
SELECT Store_type, SUM(total_amt) AS total_sales
FROM transactions
WHERE Qty > 0
GROUP BY Store_type
ORDER BY total_sales DESC
LIMIT 1;

-- QN 19
SELECT p.prod_cat,AVG(t.total_amt) AS avg_category_revenue
FROM transactions t
JOIN prod_cat_info p
ON t.prod_cat_code = p.prod_cat_code
and t.prod_subcat_code=p.prod_sub_cat_code
group by p.prod_cat
having avg(t.total_amt)>(select avg(total_amt)from transactions);

-- QN 20
SELECT p.prod_cat, p.prod_subcat, SUM(t.total_amt) AS total_revenue,
AVG(t.total_amt) AS avg_revenue FROM transactions t 
JOIN prod_cat_info p ON t.prod_cat_code = p.prod_cat_code 
AND t.prod_subcat_code = p.prod_sub_cat_code 
WHERE p.prod_cat IN ( SELECT prod_cat FROM ( SELECT p.prod_cat FROM transactions t 
JOIN prod_cat_info p ON t.prod_cat_code = p.prod_cat_code 
AND t.prod_subcat_code = p.prod_sub_cat_code
 WHERE t.Qty > 0 GROUP BY p.prod_cat ORDER BY SUM(t.Qty) DESC LIMIT 5 ) AS top5 ) 
 GROUP BY p.prod_cat, p.prod_subcat;

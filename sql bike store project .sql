create database bikestore;
use bikestore;
show tables;
select * from brands;
select count(*) as total_cus from customers;
select count(*) as total_ord from orders;
select count(*) as total_stor from stores;
select count(*) as total_product from products;
select count(*) as total_brands from brands;
select count(*) as total_staffs from staffs;
select count(*) as total_ord from order_items;
select count(*) as total_stocks from stocks;
select count(*) as total_cat from categories;

-- 1. total customers came by each store
select s.store_name,count(distinct c.customer_id) as total_customers_count
from stores s
join orders c on s.store_id=c.store_id
group by s.store_id
order by total_customers_count desc;

-- 2. total products sold by each store
select s.store_name,sum(oi.quantity) total_product_sold
from stores s 
join orders o on s.store_id=o.store_id
join order_items oi  on o.order_id=oi.order_id
group by s.store_id
order by total_product_sold desc;

-- 3.total products sold by year
select year(o.order_date) as order_year,
sum(oi.quantity) as total_product_sold from orders o 
join order_items oi on o.order_id=oi.order_id
group by year (o.order_date)
order by  total_product_sold desc;

-- 4.total product sold by brand name
SELECT b.brand_name,SUM(oi.quantity) AS total_products_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id=b.brand_id
GROUP BY b.brand_name,b.brand_id
ORDER BY total_products_sold DESC;


-- 5.total product sold by category name 
SELECT 
    c.category_name,
    SUM(oi.quantity) AS total_products_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id
ORDER BY total_products_sold DESC;


-- 6.how many staffs in store
select s.store_name,count(st.staff_id) as staff_count
from stores s
join staffs st on s.store_id=st.store_id
group by s.store_id;

-- 7.total no of orders taken by staffs in stores
select st.store_name,concat(s.first_name,' ',s.last_name) as staff_name,count(o.order_id) as total_orders
from orders o
join staffs s on o.staff_id=s.staff_id
join stores st on s.store_id=st.store_id
group by s.staff_id
order by total_orders desc;

-- 8.staff who has also managers
select concat(s2.first_name,' ',s2.last_name)as staff_name,
concat(s1.first_name,'-',s1.last_name)  as manager_name
from staffs s1
join staffs s2 on s1.staff_id=s2.manager_id;

-- 9.orders with customer,store,and staff names
select o.order_id, concat(c.first_name,' ',c.last_name)as customer_name,
st.store_name, concat(s.first_name,' ',s.last_name) as staff_name
from customers c 
join orders o on c.customer_id=o.customer_id
join staffs s on o.staff_id=s.staff_id
join stores st on s.store_id=st.store_id
order by order_id asc;

-- 10.product ordered by each customer
select distinct concat(c.first_name,' ',c.last_name) as customer,p.product_name
from customers c 
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id
order  by customer;

-- 11.store and number of products stocked
select s.store_name,count(distinct st.product_id) as product_count from stores s
join stocks st on s.store_id=st.store_id
group by s.store_id,s.store_name;

-- 12.orders with total amount and customer name
select concat(c.first_name,' ',c.last_name) as customer_name,round(sum(oi.quantity*oi.list_price*(1-oi.discount))) as total_amount 
from customers c 
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
group by c.customer_id
order by total_amount desc;

-- 13.product never ordered
select p.product_id,p.product_name from products p
left join order_items o on p.product_id=o.product_id
where o.product_id is null;

-- 14.revenue by store
select s.store_name,round(sum(oi.quantity*oi.list_price*(1-oi.discount))) as total_revenue from stores s
join orders o on s.store_id=o.store_id
join order_items oi on o.order_id=oi.order_id
group by s.store_name
order by total_revenue desc;

-- 15.product in stock but never ordered
select distinct p.product_id,p.product_name from stocks st
join products p on st.product_id =p.product_id
left join order_items oi on p.product_id=oi.product_id
where oi.product_id is null;

-- 16.list products not in stocks in any store
select product_id,PRODUCT_NAME from products
where product_id not in (select	 distinct product_id from stocks
where quantity>0);

-- 17.find staff memmbers who handled more than 10 orders
select staff_id,first_name from staffs where staff_id
 in 
 (select staff_id from orders 
 group by staff_id 
 having count(order_id)>10);

--- 18.find brands that have more than 5 products
select brand_id,brand_name from brands where brand_id in 
(select brand_id  from products
group by brand_id
having count(product_id)>5); 

select c.category_name,round(sum(oi.quantity*oi.list_price*(1-oi.discount))) as total_renevue
from categories c 
join products p on c.category_id=p.category_id
join order_items oi on p.product_id=oi.product_id
group by c.category_id
order by total_renevue desc;

-- find all products that belong to the category "mountain bikes"(where)
select product_id,product_name from products
where category_id in (select category_id from categories where category_name='mountain bikes');

-- find all products that belong to the brand "trek"(where)
select product_id,product_name from products where brand_id
in (select brand_id from brands where brand_name = 'trek');

-- find all staffs that belong to the stores"baldwin bikes"(where)
select staff_id,concat(first_name,' ',last_name) as staff_name from staffs where store_id 
in (select store_id from  stores where store_name='baldwin bikes'); 

-- find customer_details from city "san angelo"
select customer_id,first_name,phone,email,street from customers where city='san angelo';

select first_name from staffs where manager_id in
 (select manager_id from staffs where manager_id='not null');
use bikestore;
 select * from staffs;
 
 select first_name,manager_id from 
 (select first_name,manager_id from staffs where manager_id is null)staffs;
























CREATE DATABASE olist_db;
USE olist_db;


SELECT *
FROM olist_customers_dataset
LIMIT 5;


SELECT *
FROM olist_orders_dataset
LIMIT 5;


SELECT *
FROM olist_order_items_dataset
LIMIT 5;

#deliverd orders
SELECT COUNT(*) AS delivered_orders
FROM olist_orders_dataset
WHERE order_status = 'delivered';

#lastdate 
select max(order_purchase_timestamp) as last_date
from olist_orders_dataset
where order_status = 'delivered';

select c.customer_unique_id,
max(o.order_purchase_timestamp) as last_purchase
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

#recency
select c.customer_unique_id,datediff('2018-10-17',max(o.order_purchase_timestamp)) as recency
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

#frequency
select c.customer_unique_id,
count(distinct o.order_id) as frequency
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

#monetary
select c.customer_unique_id,
sum(oi.price + oi.freight_value) as monetary
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
join olist_order_items_dataset oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

select customer_unique_id,recency,
ntile(5) over (order by recency desc) as r_score
from (select c.customer_unique_id,datediff('2018-10-17',max(o.order_purchase_timestamp)) as recency
    from olist_customers_dataset c
    join olist_orders_dataset o
        on c.customer_id = o.customer_id
    where o.order_status = 'delivered'
    group by c.customer_unique_id) as rfm;

select customer_unique_id,frequency,
ntile(5) over (order by frequency desc) as f_score
from (select c.customer_unique_id,
        count(distinct o.order_id) as frequency
    from olist_customers_dataset c
    join olist_orders_dataset o
        on c.customer_id = o.customer_id
    where o.order_status = 'delivered'
    group by c.customer_unique_id
) as rfm;

select
    frequency,
    count(*) as customer_count
from (
    select
        c.customer_unique_id,
        count(distinct o.order_id) as frequency
    from olist_customers_dataset c
    join olist_orders_dataset o
        on c.customer_id = o.customer_id
    where o.order_status = 'delivered'
    group by c.customer_unique_id
) as rfm
group by frequency
order by frequency;

select count(*) as total_customers
from olist_customers_dataset;

select
    order_status,
    count(*) as order_count
from olist_orders_dataset
group by order_status;

select count(*) as total_order_items
from olist_order_items_dataset;

drop table olist_orders_dataset;
show tables;

select count(*) as total_orders
from olist_orders_dataset;

show variables like 'local_infile';
set global local_infile = 1;
show variables like 'local_infile';
drop table olist_orders_dataset;

create table olist_orders_dataset (
    order_id varchar(50),
    customer_id varchar(50),
    order_status varchar(20),
    order_purchase_timestamp datetime,
    order_approved_at datetime,
    order_delivered_carrier_date datetime,
    order_delivered_customer_date datetime,
    order_estimated_delivery_date datetime);
    
    load data local infile 'C:/Users/ACER/Desktop/olist_edaproject/data/olist_orders_dataset.csv'
into table olist_orders_dataset
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

use olist_db;
select count(*) as total_orders
from olist_orders_dataset;

truncate table olist_orders_dataset;

load data local infile 'C:/Users/ACER/Desktop/olist_edaproject/data/olist_orders_dataset.csv'
into table olist_orders_dataset
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


use olist_db;
select count(*) as total_orders
from olist_orders_dataset;

select count(*) as total_orders
from olist_orders_dataset;

select order_status,count(*) as order_count
from olist_orders_dataset
group by order_status;


select c.customer_unique_id,datediff('2018-10-17',max(o.order_purchase_timestamp)) as recency
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

select c.customer_unique_id,
count(distinct o.order_id) as frequency
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id;


select c.customer_unique_id,
sum(oi.price + oi.freight_value) as monetary
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
join olist_order_items_dataset oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

#rfm scores

select
customer_unique_id,
recency,
frequency,
monetary,
ntile(5) over(order by recency desc) as r_score,
ntile(5) over(order by frequency desc) as f_score,
ntile(5) over(order by monetary desc) as m_score
from (select c.customer_unique_id,
datediff('2018-10-17', max(o.order_purchase_timestamp)) as recency,
count(distinct o.order_id) as frequency,
sum(oi.price + oi.freight_value) as monetary
from olist_customers_dataset c
join olist_orders_dataset o
on c.customer_id = o.customer_id
join olist_order_items_dataset oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_unique_id) rfm;



create table rfm_scores as
select *, ntile(5) over(order by recency desc) r_score,
ntile(5) over(order by frequency desc) f_score,
ntile(5) over(order by monetary desc) m_score
from (select c.customer_unique_id,
datediff('2018-10-17',max(o.order_purchase_timestamp)) recency,
count(distinct o.order_id) frequency,
sum(oi.price+oi.freight_value) monetary
from olist_customers_dataset c
join olist_orders_dataset o on c.customer_id=o.customer_id
join olist_order_items_dataset oi on o.order_id=oi.order_id
where o.order_status='delivered'
group by c.customer_unique_id) x;

#segments

select *,
case
when r_score >= 4 and f_score >= 4 then 'Champions'
when r_score >= 3 and f_score >= 3 then 'Loyal'
when r_score >= 3 then 'Potential Loyalists'
when f_score >= 3 then 'At Risk'
else 'Lost'
end as segment
from rfm_scores;
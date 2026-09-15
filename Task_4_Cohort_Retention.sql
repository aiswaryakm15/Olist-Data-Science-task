use olist_db;
select
c.customer_unique_id,
date_format(min(o.order_purchase_timestamp), '%Y-%m-01') as cohort_month
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

select distinct
c.customer_unique_id,
date_format(o.order_purchase_timestamp, '%Y-%m-01') as purchase_month
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered';

with customer_cohort as (select c.customer_unique_id,
date_format(min(o.order_purchase_timestamp), '%Y-%m-01') as cohort_month
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id)

select
cc.cohort_month,
timestampdiff(month, cc.cohort_month,
date_format(o.order_purchase_timestamp, '%Y-%m-01')) as month_number,
count(distinct cc.customer_unique_id) as customers
from customer_cohort cc
join olist_customers_dataset c
on cc.customer_unique_id = c.customer_unique_id
join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
and timestampdiff(month, cc.cohort_month,
date_format(o.order_purchase_timestamp, '%Y-%m-01')) between 0 and 6
group by cc.cohort_month, month_number
order by cc.cohort_month, month_number;

select
date_format(o.order_purchase_timestamp, '%Y-%m-01') as purchase_month,
count(distinct c.customer_unique_id) as customers
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by purchase_month
order by purchase_month;

select
date_format(o.order_purchase_timestamp, '%Y-%m-01') as cohort_month,
count(distinct c.customer_unique_id) as customers
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by cohort_month
order by cohort_month;

select
c.customer_unique_id,
date_format(min(o.order_purchase_timestamp), '%Y-%m-01') as cohort_month
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id;

with cohort as (select c.customer_unique_id,
date_format(min(o.order_purchase_timestamp), '%Y-%m-01') as cohort_month
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id)

select cohort_month,
count(distinct customer_unique_id) as customers
from cohort
group by cohort_month
order by cohort_month;

with cohort as (select
c.customer_unique_id,
date_format(min(o.order_purchase_timestamp), '%Y-%m-01') as cohort_month
from olist_orders_dataset o
join olist_customers_dataset c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id)

select
cohort.cohort_month,
date_format(o.order_purchase_timestamp, '%Y-%m-01') as purchase_month,
count(distinct cohort.customer_unique_id) as repeat_customers
from cohort
join olist_customers_dataset c
on cohort.customer_unique_id = c.customer_unique_id
join olist_orders_dataset o
on c.customer_id = o.customer_id
where o.order_status = 'delivered'
and date_format(o.order_purchase_timestamp, '%Y-%m-01') > cohort.cohort_month
group by cohort.cohort_month, purchase_month
order by cohort.cohort_month, purchase_month;
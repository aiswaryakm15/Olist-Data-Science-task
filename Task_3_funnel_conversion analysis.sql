select count(*) as orders_placed
from olist_orders_dataset;

select count(distinct order_id) as orders_paid
from olist_order_payments_dataset;


select count(*) as orders_shipped
from olist_orders_dataset
where order_status = 'shipped';

select count(*) as orders_delivered
from olist_orders_dataset
where order_status = 'delivered';

select count(distinct order_id) as orders_reviewed;


select 'Orders placed' as stage,
count(*) as order_count,
100 as conversion_percent,
0 as drop_off_percent
from olist_orders_dataset

union all

select 'Orders paid',
count(distinct order_id),
round(count(distinct order_id) /
(select count(*) from olist_orders_dataset) * 100, 2),
round(100 - count(distinct order_id) /
(select count(*) from olist_orders_dataset) * 100, 2)
from olist_order_payments_dataset

union all

select 'Orders shipped',
count(*),
round(count(*) /
(select count(*) from olist_orders_dataset) * 100, 2),
round(100 - count(*) /
(select count(*) from olist_orders_dataset) * 100, 2)
from olist_orders_dataset
where order_status = 'shipped'

union all

select 'Orders delivered',
count(*),
round(count(*) /
(select count(*) from olist_orders_dataset) * 100, 2),
round(100 - count(*) /
(select count(*) from olist_orders_dataset) * 100, 2)
from olist_orders_dataset
where order_status = 'delivered'

union all

select 'Orders reviewed',
count(distinct order_id),
round(count(distinct order_id) /
(select count(*) from olist_orders_dataset) * 100, 2),
round(100 - count(distinct order_id) /
(select count(*) from olist_orders_dataset) * 100, 2)
from olist_order_reviews_dataset;

select
order_status,
count(*) as order_count
from olist_orders_dataset
group by order_status;

select
count(distinct o.order_id) as orders_paid
from olist_orders_dataset o
join olist_order_payments_dataset p
on o.order_id = p.order_id;
use olist_db;

select count(*) as total_reviews
from olist_order_reviews_dataset;

select count(distinct r.order_id) as matched_reviews;

select
order_status,
count(*) as order_count
from olist_orders_dataset
group by order_status
order by order_count desc;

select count(distinct order_id) as delivered_orders
from olist_orders_dataset
where order_status = 'delivered';

select count(distinct order_id) as shipped_orders
from olist_orders_dataset
where order_status = 'shipped';

-- Note: There is a mismatch in the order status data.
-- Shipped orders = 405, while delivered orders = 34,029.
-- This causes an unusually high delivered conversion percentage.
select
'Orders placed' as stage,
35071 as order_count,
100.00 as conversion_percent,
0.00 as drop_off_percent

union all

select
'Orders paid',
15312,
round(15312 / 35071 * 100, 2),
round(100 - (15312 / 35071 * 100), 2)

union all

select
'Orders shipped',
405,
round(405 / 15312 * 100, 2),
round(100 - (405 / 15312 * 100), 2)

union all

select
'Orders delivered',
34029,
round(34029 / 405 * 100, 2),
round(100 - (34029 / 405 * 100), 2)

union all

select
'Orders reviewed',
115,
round(115 / 34029 * 100, 2),
round(100 - (115 / 34029 * 100), 2);

use olist_db;
select
seller_id,
sum(price) as revenue,
sum(price - freight_value) as profit
from olist_order_items_dataset
group by seller_id
order by revenue desc;

select
seller_id,
sum(price) as revenue,
sum(price - freight_value) as profit,
round(sum(price - freight_value) / sum(price) * 100, 2) as profit_margin
from olist_order_items_dataset
group by seller_id
order by profit desc;

select
seller_id,
sum(price) as revenue,
sum(price - freight_value) as profit,
round(sum(price - freight_value) / sum(price) * 100, 2) as profit_margin,
rank() over(order by sum(price - freight_value) desc) as profit_rank
from olist_order_items_dataset
group by seller_id
order by profit_rank;
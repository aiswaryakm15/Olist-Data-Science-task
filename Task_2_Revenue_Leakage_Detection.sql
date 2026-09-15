USE OLIST_DB;
show tables;

select * from olist_order_items_dataset
limit 5;

select order_id,sum(price + freight_value) as expected_amount
from olist_order_items_dataset
group by order_id;

select
    order_id,
    sum(payment_value) as paid_amount
from olist_order_payments_dataset
group by order_id;
show tables;

select
    oi.order_id,
    sum(oi.price + oi.freight_value) as expected_amount,
    sum(op.payment_value) as paid_amount
from olist_order_items_dataset oi
join olist_order_payments_dataset op
on oi.order_id = op.order_id
group by oi.order_id;


select oi.order_id,
sum(oi.price + oi.freight_value) as expected_amount,
sum(op.payment_value) as paid_amount,
sum(op.payment_value) - sum(oi.price + oi.freight_value) as difference
from olist_order_items_dataset oi
join olist_order_payments_dataset op
on oi.order_id = op.order_id
group by oi.order_id;

select
    oi.order_id,
    sum(oi.price + oi.freight_value) as expected_amount,
    sum(op.payment_value) as paid_amount,
    round((sum(op.payment_value) - sum(oi.price + oi.freight_value))
        / sum(oi.price + oi.freight_value) * 100,2) as difference_percent
from olist_order_items_dataset oi
join olist_order_payments_dataset op
on oi.order_id = op.order_id
group by oi.order_id;

select
oi.order_id,
sum(oi.price + oi.freight_value) as expected_amount,
sum(op.payment_value) as paid_amount,
round((sum(op.payment_value) - sum(oi.price + oi.freight_value))/ sum(oi.price + oi.freight_value) * 100, 2) as difference_percent
from olist_order_items_dataset oi
join olist_order_payments_dataset op
on oi.order_id = op.order_id
group by oi.order_id
having abs((sum(op.payment_value) - sum(oi.price + oi.freight_value))/ sum(oi.price + oi.freight_value)) > 0.02;

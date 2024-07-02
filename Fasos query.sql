drop table if exists driver;
CREATE TABLE driver(driver_id integer,reg_date date); 

INSERT INTO driver(driver_id,reg_date) 
 VALUES (1,'01-01-2021'),
(2,'01-03-2021'),
(3,'01-08-2021'),
(4,'01-15-2021');

drop table if exists ingredients;
CREATE TABLE ingredients(ingredients_id integer,ingredients_name varchar(60)); 

INSERT INTO ingredients(ingredients_id ,ingredients_name) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

drop table if exists rolls;
CREATE TABLE rolls(roll_id integer,roll_name varchar(30)); 

INSERT INTO rolls(roll_id ,roll_name) 
 VALUES (1	,'Non Veg Roll'),
(2	,'Veg Roll');

drop table if exists rolls_recipes;
CREATE TABLE rolls_recipes(roll_id integer,ingredients varchar(24)); 

INSERT INTO rolls_recipes(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

drop table if exists driver_order;
CREATE TABLE driver_order(order_id integer,driver_id integer,pickup_time datetime,distance VARCHAR(7),duration VARCHAR(10),cancellation VARCHAR(23));
INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) 
 VALUES(1,1,'01-01-2021 18:15:34','20km','32 minutes',''),
(2,1,'01-01-2021 19:10:54','20km','27 minutes',''),
(3,1,'01-03-2021 00:12:37','13.4km','20 mins','NaN'),
(4,2,'01-04-2021 13:53:03','23.4','40','NaN'),
(5,3,'01-08-2021 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'01-08-2020 21:30:45','25km','25mins',null),
(8,2,'01-10-2020 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'01-11-2020 18:50:20','10km','10minutes',null);

drop table if exists customer_orders;
CREATE TABLE customer_orders(order_id integer,customer_id integer,roll_id integer,not_include_items VARCHAR(4),extra_items_included VARCHAR(4),order_date datetime);
INSERT INTO customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
values (1,101,1,'','','01-01-2021  18:05:02'),
(2,101,1,'','','01-01-2021 19:00:52'),
(3,102,1,'','','01-02-2021 23:51:23'),
(3,102,2,'','NaN','01-02-2021 23:51:23'),
(4,103,1,'4','','01-04-2021 13:23:46'),
(4,103,1,'4','','01-04-2021 13:23:46'),
(4,103,2,'4','','01-04-2021 13:23:46'),
(5,104,1,null,'1','01-08-2021 21:00:29'),
(6,101,2,null,null,'01-08-2021 21:03:13'),
(7,105,2,null,'1','01-08-2021 21:20:29'),
(8,102,1,null,null,'01-09-2021 23:54:33'),
(9,103,1,'4','1,5','01-10-2021 11:22:59'),
(10,104,1,null,null,'01-11-2021 18:34:49'),
(10,104,1,'2,6','1,4','01-11-2021 18:34:49');

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;

How Many rolls,unique orders were ordered ?
select customer_id,count(distinct customer_id)as unique_orders,count(roll_id) as rolls_ordered from customer_orders
group by customer_id

select * from customer_orders
select * from rolls

how many successful orders were delivered by each driver
select count( distinct order_id) as successful_orders,driver_id from driver_order
where cancellation  not in ('Cancellation','Customer Cancellation')
group by driver_id

How many each type of rolls were  delivered ?
select a.roll_id,count(a.roll_id) as rolls_delivered  from customer_orders  a 
 join driver_order c
on  a.order_id=c.order_id 
where cancellation not in ('Cancellation','Customer Cancellation')
group by a.roll_id

select * from customer_orders;
select * from driver_order;


How many each type of role were delivered?
select roll_id,count(roll_id) from customer_orders where order_id in (select order_id  from 
(select * ,(case when cancellation in('Cancellation','Customer Cancellation') then 'c' else 'nc' end )as 
cancelled_details from driver_order) A where cancelled_details='nc')
group by roll_id

how many veg and non veg rolls were ordered by each customer?
select * from customer_orders;
select * from rolls

select a.customer_id,count(a.roll_id) as no_of_rolls_ordered ,b.roll_name from customer_orders a 
join rolls b on a.roll_id=b.roll_id
group by b.roll_name,a.customer_id

What was the maximum no of rolls delivered in single order?

select * from customer_orders;
select * from driver_order
select * from(select * ,rank() over (order by rolls_delivered desc) as rn from
(select order_id,count(roll_id) as rolls_delivered from customer_orders where order_id in (select order_id  from 
(select * ,(case when cancellation in('Cancellation','Customer Cancellation') then 'c' else 'nc' end )as 
cancelled_details from driver_order) A where cancelled_details='nc')
group by order_id)B )D where rn=1
--order by rolls_delivered desc

For each customer how many rolls delivered had atleast one change and how many had no change?
select count(roll_id) as rolls_atleast_one_change from 
(select*, case when not_include_items in('4','2.6')then 'c' else 'nc' end as change1_orders ,
case when extra_items_included in('1','1.5','1.4')then 'c' else 'nc' end as change2_orders  from customer_orders where order_id in
(select order_id from 
(select order_id ,case when cancellation in ('Cancellation','Customer Cancellation')then 'c' else 'nc'end as cancelled_orders 
from driver_order ) A where cancelled_orders='nc'))B where change1_orders ='c' or  change2_orders='c'

select count(roll_id) as rolls_no_change from 
(select*, case when not_include_items in('4','2.6')then 'c' else 'nc' end as change1_orders ,
case when extra_items_included in('1','1.5','1.4')then 'c' else 'nc' end as change2_orders  from customer_orders where order_id in
(select order_id from 
(select order_id ,case when cancellation in ('Cancellation','Customer Cancellation')then 'c' else 'nc'end as cancelled_orders 
from driver_order ) A where cancelled_orders='nc'))B where change1_orders ='nc' and  change2_orders='nc'

select*, case when not_include_items in('4','2.6')then 'c' else 'nc' end as change1_orders ,
case when extra_items_included in('1','1.5','1.4')then 'c' else 'nc' end as change2_orders  from customer_orders where order_id in
(select order_id from 
(select order_id ,case when cancellation in ('Cancellation','Customer Cancellation')then 'c' else 'nc'end as cancelled_orders 
from driver_order ) A where cancelled_orders='nc')
 

with temp_customer_orders(order_id ,customer_id ,roll_id,not_include_items,extra_items_included ,order_date)as
(select order_id ,customer_id ,roll_id,
 case when not_include_items=' ' or not_include_items is null then '0'
else not_include_items end as new_not_include_items
, case when extra_items_included='NaN' or extra_items_included is null or extra_items_included=' ' then '0'
else extra_items_included end as new_extra_items_included ,order_date from customer_orders)
,temp_driver_orders(order_id,driver_id,pickup_time,distance,duration,cancelled_orders) as
(select order_id,driver_id,pickup_time,distance,duration,
case when cancellation in ('Cancellation','Customer Cancellation')then '0'
else '1' end as cancelled_orders 
from driver_order)
select customer_id ,chg_no_chg,count(order_id) from
(select *,case when extra_items_included='0' and not_include_items='0' then
'no_change' else 'change' end as chg_no_chg 
from temp_customer_orders
where order_id in(
select order_id from temp_driver_orders where cancelled_orders ='1'))A
group by customer_id ,chg_no_chg

How many rolls were delivered that had both exclusions and extras
select * from customer_orders
select * from driver_order

with temp_customer_orders(order_id ,customer_id ,roll_id,not_include_items,extra_items_included ,order_date)as
(select order_id ,customer_id ,roll_id,
 case when not_include_items=' ' or not_include_items is null then '0'
else not_include_items end as new_not_include_items
, case when extra_items_included='NaN' or extra_items_included is null or extra_items_included=' ' then '0'
else extra_items_included end as new_extra_items_included ,order_date from customer_orders)
, temp_driver_orders(order_id,driver_id,pickup_time,distance,duration,cancelled_orders) as
(select order_id,driver_id,pickup_time,distance,duration,
case when cancellation in ('Cancellation','Customer Cancellation')then '0'
else '1' end as cancelled_orders 
from driver_order)
select chg_no_chg,count(order_id) from
(select *,case when extra_items_included!='0' and not_include_items!='0' then
'exclusion_extra' else 'no_exclusion_extra' end as chg_no_chg 
from temp_customer_orders
where order_id in(
select order_id from temp_driver_orders where cancelled_orders ='1'))A
group by chg_no_chg

what was the total rolls ordered each hour of the day?
select count(roll_id)as rolls_ordered ,datepart(day,order_date)as ordered_date
,datepart(HOUR,order_date)as ordered_hour from customer_orders
group by datepart(day,order_date),datepart(HOUR,order_date)
order by datepart(day,order_date),datepart(HOUR,order_date)

what was the number of orders for each day of week?
select count(distinct order_id),DATENAME(DW,order_date)
from customer_orders
group by DATENAME(DW,order_date)

what was the average time in minutes for each driver to reach fassos hq to pick up the order?
select * from customer_orders
select * from driver_order
select * ,DATEDIFF(MINUTE,a.order_date,b.pickup_time)as time_reach_hq
from customer_orders a join driver_order b
on a.order_id=b.order_id
where 
 b.pickup_time is not null

 Is there a relationship b/w no of orders and time it takes to prepare the rolls?
select order_id ,count(roll_id),sum(diff) from (select *,DATEDIFF(MINUTE,a.order_date,b.pickup_time)as diff
from customer_orders a
join driver_order b on a.order_id =b.order_id 
where b.pickup_time is not null)a 
group by order_id;

what is the average distance travelled for each customer
select a.order_id,a.customer_id ,sum(cast(trim(replace(b.distance,'km',' '))as decimal(4,2)) from customer_orders a
  join driver_order b on a.order_id=b.order_id 

  difference between longest and shortest delivery time?
 select max(new_duration)-min(new_duration)as diff from  
 (select *,cast(substring(duration,1,2) as int)as new_duration  from driver_order
  where duration is not null) A

What is the average speed for each driver?
select driver_id,(new_distance/new_duration) as avg_speed from
(select * ,cast(substring(duration,1,2) as int)as new_duration ,cast(trim(replace(distance,'km',' '))as decimal(4,2))
 as new_distance  from driver_order where distance is not null and duration is not null )A

 what is successful delivery percentage for each driver?
select driver_id,sum(can_orders) s ,count(driver_id) c from
(select driver_id,(case when  lower(cancellation) like'%cancel%' then 0 else 1 end )
as can_orders 
 from driver_order)A
 group by driver_id


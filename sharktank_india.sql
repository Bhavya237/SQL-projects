select * from shark_tank

total episodes
select count( distinct Ep_no) from shark_tank

pitches
select count( distinct Brand) as no_of_pitches from shark_tank

pitches converted
select count(*) from shark_tank
where [Total investors]!=0

total males
select sum(male) from shark_tank

total females
select sum(female) from shark_tank

gender ratio
select sum(female)/sum(male) from shark_tank

total invested amount
select sum([Amount Invested lakhs])  from shark_tank

avg equity taken
select avg(a.[Equity Taken %]) from
(select ([Equity Taken %]) from shark_tank where [Equity Taken %]>0)a

highest deal taken
select Deal from shark_tank where Deal!='No Deal'
order by Deal desc

select max([Amount Invested lakhs]) from shark_tank

highest equity taken
select max([Equity Taken %]) from shark_tank

pitches with atleast one female contestant
select count(*) as no_of_pitches_withatleast_one_woman from
(select *,case when female>=1 then 1 else 0 end as atleast_one_female from shark_tank)a
where atleast_one_female=1

pitches converted having atleast one woman
select count(*) as no_of_converted_pitches_withatleast_one_woman from
(select *,case when female>=1 then 1 else 0 end as atleast_one_female from shark_tank)a
where atleast_one_female=1 and deal!='No Deal'

average team members
select avg([Team members]) from shark_tank

amount invested per deal
select count(*),sum(a.[Amount Invested lakhs]),sum(a.[Amount Invested lakhs])/count(*) as amount_invested_per_deal from
(select * from shark_tank where [Amount Invested lakhs]!=0)a

average age group of contestants
select ([Avg age]),count([Avg age]) cnt  from shark_tank
group by  ([Avg age])
order by cnt desc

location group of contestants
select Location,count([Location])  cnt from shark_tank
group by  Location
order by cnt desc

sector group of contestants
select * from shark_tank
select Sector,count([Sector])  cnt from shark_tank
group by  Sector
order by cnt desc

partner deals
select * from shark_tank
select Partners,count(Partners)  cnt from shark_tank
where Partners !='-'
group by  Partners
order by cnt desc

select a.keyy,a.deals_present,b.amount_invested,b.avg_equity_taken,b.deals_converted from 
(select 'Ashneer' as keyy,count([Ashneer Amount Invested]) as deals_present  from shark_tank
where ([Ashneer Amount Invested]) is not null)a
inner join
(select 'Ashneer' as keyy, count([Ashneer Amount Invested]) as deals_converted ,avg([Ashneer Equity Taken %]) as avg_equity_taken ,sum([Ashneer Amount Invested]) as amount_invested 
from shark_tank
where ([Ashneer Amount Invested]) is not null and  ([Ashneer Amount Invested]) >0)b
on a.keyy=b.keyy

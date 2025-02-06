select * from fact_internet_sales;
alter table fact_internet_sales add column Sales float after orderquantity;
update fact_internet_sales set sales=orderquantity*unitprice;
alter table sales add column profit float after sales;
update sales set profit=sales-productstandardcost;
select * from factinternetsalesnew;
select * from sales;
-- I .Append/Union of Fact Internet sales and Fact internet sales new -SALES
create table sales as
select * from fact_internet_sales
union all
select * from factinternetsalesnew;
select * from sales;
-- fields from the datekey field
select date,
year(date) as year,
month(date) as month ,
monthname(date) as monthname,
quarter(date) as Quarter,
CONCAT(YEAR(date), '-', LEFT(MONTHNAME(date), 3)) AS YearMonth,
(weekday(date)+1) as weekday,
dayname(date) as weekdayname,
CASE 
    WHEN MONTH(date) IN (4,5,6) THEN 'Q1'
    WHEN MONTH(date) IN (7,8,9) THEN 'Q2'
    WHEN MONTH(date) IN (10,11,12) THEN 'Q3'
    ELSE 'Q4'
END AS FinancialQuarter
from dimdate
;
-- Calculate the Sales amount using the columns
select ProductKey,
round((UnitPrice*OrderQuantity)-DiscountAmount,2)
 as Sales
from sales;
-- Calculate the Productioncost using the columns
select productkey,
round((unitprice*orderquantity),2) 
as ProductionCost
from sales;
-- Calculate the Profit.
select ProductKey,
round((sales-Productstandardcost),2) 
as profit
from sales;
-- Quarter Wise Sales
select concat("Q",quarter(orderdate)) as Quarter,
round(sum(sales),2) as sales 
from sales
group by quarter
order by quarter;
-- year Wise sales
select year(OrderDate) as YEAR,
round(sum(sales),2) as sales 
from sales 
group by year
order by year;
-- month wise sales
select monthname(OrderDate) as Month,
round(sum(sales),2) as sales 
from sales group by Month
order by min(month(orderdate));
-- sales and production cost
select concat("Q",quarter(orderdate)) as Quarter,
round(sum(sales),2) as sales,
round(sum(productstandardcost),2) as productioncost
from sales 
group by quarter
order by quarter;
-- Total customers
select distinct count(customerkey) 
as Total_Customers 
from sales;
-- Total Sales
select round(sum(sales),2) 
as Total_Sales
from sales;
-- Total Profit
select round(sum(profit),2 ) 
as TotalProfit
from sales;
-- Total productioncost
select round(sum(productstandardcost),2)
 as TotalProductionCost
from sales;
-- Total Customers
select distinct count(customerkey) as TotalCustomers
from sales;

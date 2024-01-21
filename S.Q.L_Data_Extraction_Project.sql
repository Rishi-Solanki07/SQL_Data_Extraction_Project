
    USE adventureworks ;


-- 1. What are the top 10 highest selling products in the database? 
-- (Hint - Use salesorderdetail as base table, LineTotal as Sales)
-- Create a Pie chart to depict this information



                                                 #  Question_1

select c.Product_ID, c.Product_Name, sum(c.Total_Sales) as Total_Sales 
from 
(
select a.Productid as Product_ID, b.`Name` as Product_Name, a.linetotal as Total_Sales 
from salesorderdetail as a 
left join 
product as b  on   a.productid = b.productid 
) as c 
group by c.Product_ID
order by sum(c.Total_Sales) desc
limit 10 ;



-- ***************************************************************************************************************************



-- 2. Who are the top 10 highest spending customers in the data along with their address and address type information?
-- (Hint - Use salesorderheader as base table, TotalDue as sales) 
-- Create a Bar chart to depict this information.



											    # Question 2

select e.customerid, concat(b.firstname," ",b.lastname) as Customer_Name  , d.addressline1, d.city,
 a.`Name` as Addresstype, e.Total_Purchase  
from 
(
select contactid, customerid, sum(totaldue) as Total_Purchase
from salesorderheader  
group by customerid,contactid
order by  sum(totaldue) desc 
limit 10 
 ) as e 
 join contact as b on             e.contactid = b.contactid
 join customeraddress  as c  on   e.customerid = c.customerid
 join address  as d on            c.addressid = d.addressid 
 join addresstype as a  on        a.addresstypeid = c.addresstypeid  ;



-- ***************************************************************************************************************************


-- 3. Calculate the Sales by Sales Reason Name and Reason Type. 
-- Also find the best & worst performing Sales Reason in terms of Sales (Hint-Use salesorderheader as base table,TotalDue as sales)
-- Create a Bar chart to depict this information.


												  # Question 3


select * from                                                 
 (                                                 
 select c.`Name` as Reason , c.reasontype as Reason_Type, sum(a.totaldue) as Total_Sales                                                  
from salesorderheader as a
join salesorderheadersalesreason as b on   a.salesorderid = b.salesorderid
join salesreason as c                 on b.salesreasonid = c.salesreasonid    
group by c.`Name`, c.Reasontype 
) as d
order by d.total_sales desc ;


 -- All  sales reason names and it's type
select salesreasonid,`Name` as Reason_Name, ReasonType from salesreason ;


-- ***************************************************************************************************************************

-- Calculate the average number of orders shipped by different Ship methods for each month and year
-- (Hint - Use salesorderheader as base table, TotalDue as sales)
-- Create a Line chart to depict this information.


  												       # Question 4


select *, avg(c.order_count) over (partition by c.Year_, c.Month_) as avg_per_Month,
sum(c.order_count)  over (partition by c.Year_)/2 as avg_per_year  
from 
(
select year(a.orderdate) as Year_, month(a.orderdate) as Month_, a.shipmethodid, b.`Name`, count(a.salesorderid) as order_count
from salesorderheader as a
join shipmethod as b  on   a.shipmethodid =b.shipmethodid 
group by year_, Month_, a.shipmethodid, b.`Name`
) as c 
order by c.year_, c.Month_, c.shipmethodid ;




-- *******************************************************************************************************************************

-- Calculate the count of orders, maximum and minimum shipped by different Credit Card Type for each month and year 
-- (Hint - Use salesorderheader as base table, TotalDue as sales)
-- Create a chart as per your choice to depict this information.



                                                    # Question-5
											
select *, 
min(c.order_count) over(partition by c.year_) as min_per_year, 
max(c.order_count) over (partition by c.year_)as  max_per_year, 
min(c.order_count) over(partition by c.year_, c.month_)as  min_per_month,
max(c.order_count) over(partition by c.year_, c.month_) as max_per_month
 from 
(
select year(a.orderdate) as year_, month(a.orderdate) as Month_, b.cardtype as Card_Type, 
count(a.salesorderid) as Order_Count
from salesorderheader as a 
join creditcard as b         on a.creditcardid = b.creditcardid 
group by year_, month_, card_type 
) as c ;



-- *******************************************************************************************************************************                                              
 
--  Which are the top 3 highest selling Sales Person by Territory for each month and year
-- (Hint - Use salesorderheader as base table, TotalDue as sales)
-- Create a chart as per your choice to depict this information.
 
													# Question-6
   
select * 
from 
(
select year(a.orderdate) as Year_, month(a.orderdate) as Month_, b.`Name` as Territory,
 a.salespersonid as Sales_Person_Id, sum(a.totaldue) as Total_Sales,
 dense_rank() over (partition by year(a.orderdate), Month(a.orderdate), b.`Name` order by sum(a.totaldue) desc ) as Rank_ 
from salesorderheader   as a 
join salesterritory     as b        on  a.territoryid = b.territoryid 
group by Territory, Sales_Person_id, Year_, Month_ 
) as c 
where c.Rank_ <= 3 
order by c.Year_, c.Month_, c.Territory, c.Rank_ ;



-- *******************************************************************************************************************************

-- Calculate the count of employees and average tenure per department name and department group name.
-- (Hint - Use employee as base table, Tenure is calculated in days – from Hire date to today)
-- Create a table to depict this information

										    	# Question-7


select  c.departmentid as Department_ID, c.`Name` as Department , c.groupname, count(distinct a.employeeid) as Employee_Counts, 
avg(DATEDIFF(CURDATE(), a.hiredate)) AS tenure_in_days
from employee as a 
join employeedepartmenthistory as b   on a.employeeid = b.employeeid
join department                as c   on b.departmentid = c.departmentid
group by Department_ID, department,c.Groupname
order by Department_ID ;


--                                                THANK YOU


create database amazon;
use amazon;

select * from amazon;

Alter table amazon rename column `Invoice ID` to Invoice_Id;
Alter table amazon rename column `Customer type` to Customer_type;
Alter table amazon rename column `Product line` to Product_line;
Alter table amazon rename column `Unit price` to Unit_price;
Alter table amazon rename column `Tax 5%` to VAT;
Alter table amazon add timeofday varchar(30);

Update amazon set timeofday = Case When Time Between '06:00:00' and '11:59:59' Then "Morning"
When Time Between '12:00:00' and '17:59:59' Then "Afternoon"
When Time Between '18:00:00' and '23:59:59' Then "Evening"
Else "Night"
END;

Alter table amazon add dayname varchar(30);
Update amazon set dayname = dayname(Date);

Alter table amazon add monthname varchar(30);
Update amazon set monthname = monthname(Date);

select * from amazon;

#1 Count of Distinct Cities
Select count(distinct city) as Count_of_Cities from amazon;

#2 each branch corresponding cities
Select distinct branch, city from amazon;

#3 count of distinct product line
Select count(distinct Product_line) as Count_of_distinct_Productline from amazon;

#4 most used payment method
Select Payment, count(Payment) from amazon group by Payment limit 1;

#5 product line with highest sales
Select Product_line, round(sum(Quantity * Unit_price),2) as Total_Sales from amazon 
group by Product_line
order by Total_Sales desc limit 1;

#6 monthwise sales
Select monthname, round(sum(Quantity * Unit_price),2) as Revenue from amazon group by monthname;

#7 cogs peaks month
Select monthname, round(sum(cogs),2) as Total_cogs from amazon 
group by monthname
order by Total_cogs desc limit 1;

#8 product line has highest revenue
Select Product_line, round(sum(Quantity * Unit_price),2) as Revenue from amazon group by Product_line
order by Revenue Desc limit 1;

#9 City with highest revenue
Select city, round(sum(Quantity * Unit_price),2) as Revenue from amazon group by city
order by Revenue Desc limit 1;

#10
Select Product_line, round(sum(Vat),2) as Total_VAT from amazon group by Product_line 
order by Total_VAT DESC limit 1;

#11
Select Product_line, CASE WHEN sum(Quantity * Unit_price) > avg(Quantity * Unit_price) THEN "Good"
Else "Bad" END as Sales_Rating from amazon group by Product_line;

#12
Select branch, sum(Quantity) as Total_Quantity from amazon group by branch having 
Total_Quantity > (Select avg(Total_Quantity) from (Select sum(Quantity) as Total_Quantity from amazon
group by branch) as branch_totals);

#13
with genproduct as (Select gender, Product_line, count(*) as Count from amazon 
group by gender, Product_line)
select * from genproduct where (gender, Count) in 
(Select gender, max(Count) from genproduct group by gender);

#14 Average rating for each product line.
Select Product_line, round(avg(rating),2) as Rating from amazon group by Product_line;

#15
Select dayname, timeofday, count(*) as Sales_Count from amazon group by dayname, timeofday;

#16
Select Customer_type, round(sum(Quantity * Unit_price),2) as Revenue from amazon group by Customer_type
order by Revenue Desc limit 1;

#17
Select city, max((vat*100)/Total) as Percentage from amazon group by city;

#18 Highest VAT Payments with customer type
Select Customer_type, round(sum(VAT),2) as Total_VAT from amazon 
group by Customer_type order by Total_VAT DESC limit 1;

#19 Count of Distinct Customer types
Select count(Distinct Customer_type) as Distinct_Customer_types from amazon;

#20 Count of Distinct Payment methods
Select count(Distinct Payment) as Distinct_Payment_Methods from amazon;

#21
Select Customer_type, count(Customer_type) as Count from amazon group by Customer_type
order by Count Desc limit 1;

#22
Select Customer_type, count(*) as Purchase_Frequency from amazon group by Customer_type
order by Purchase_Frequency Desc limit 1;

#23
Select gender, count(*) as Count from amazon group by gender order by count desc limit 1;

#24
Select branch, gender, count(*) as Count from amazon group by branch, gender order by branch, gender;

#25
Select timeofday, count(*) as Rating_Count from amazon group by timeofday
order by Rating_Count DESC limit 1;

#26
With maxrating as (Select branch, timeofday, max(Rating) as max_rating from amazon 
group by branch, timeofday)
Select * from maxrating where (branch,max_rating) in 
(select branch,max(max_rating) from maxrating group by branch);

#27
Select dayname, round(avg(Rating),2) as avg_rating from amazon group by dayname 
order by avg_rating desc limit 1;

#28
Select branch, dayname, round(avg(Rating),2) as avg_rating from amazon group by branch,dayname 
order by avg_rating desc;
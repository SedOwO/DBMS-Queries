-- SALESMAN (Salesman_id, Name, City, Commission) 
-- CUSTOMER (Customer_id, Cust_Name, City, Grade, Salesman_id)
-- ORDERS (Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id) 

create table salesman (
	salesman_id int,
	name varchar(20),
	city varchar(20),
	comission varchar(20),
	primary key(salesman_id)
);

create table customers (
	customer_id int,
	cust_name varchar(20),
	city varchar(20),
	grade int,
	salesman_id int,
	primary key(customer_id),
	foreign key (salesman_id) references salesman(salesman_id) on delete set null
);

create table orders (
	ord_no int,
	purchase_amt number(10, 2);
	ord_date date,
	customer_id int,
	salesman_id int,
	primary key(ord_no),
	foreign key (customer_id) references customers(customer_id) on delete cascade,
	foreign key (salesman_id) references salesman(salesman_id) on delete cascade
);

INSERT INTO SALESMAN VALUES	(1000, 'JOHN','BANGALORE','25 %'),
							(2000, 'RAVI','BANGALORE','20 %'),
							(3000, 'KUMAR','MYSORE','15 %'),
							(4000, 'SMITH','DELHI','30 %'),
							(5000, 'HARSHA','HYDRABAD','15 %');

INSERT INTO CUSTOMER1 VALUES 	(10, 'PREETHI','BANGALORE', 100, 1000),
								(11, 'VIVEK','MANGALORE', 300, 1000),
								(12, 'BHASKAR','CHENNAI', 400, 2000),
								(13, 'CHETHAN','BANGALORE', 200, 2000),
								(14, 'MAMATHA','BANGALORE', 400, 3000);

INSERT INTO ORDERS VALUES 	(50, 5000, '2017-05-04', 10, 1000),
							(51, 450, '2017-01-20', 10, 2000),
							(52, 1000, '2017-02-24', 13, 2000),
							(53, 3500, '2017-04-13', 14, 3000),
							(54, 550, '2017-03-09', 12, 2000);

-- Count the customers with grades above Bangalore's average. 
select grade, count(*) as below_average 
	from customers
		group by grade
			having grade > (select avg(grade) from customers where city = 'Bengaluru');

-- Find the name and numbers of all salesmen who had more than one customer.
select name, salesman_id
	from salesman
		where 1 < (select count(*) from customers where salesman_id = salesman.salesman_id);

use orders;

-- List all salesman and indicate those who have and don't have customers in their cities
select salesman.salesman_id, name, c_name, commission
from salesman, customers
where salesman.city = customers.city
union
select salesman_id, name, 'no match', commission
from salesman
where not city = any 
(select city from customers) order by 2 desc;

-- Create a view that finds the salesman who has the customer with the higest order of a day
create view elitesalesman as
select O.ord_date, S.salesman_id, S.name
from salesman S, orders O 
where S.salesman_id = O.salesman_id
and O.purchase_amt = (select max(purchase_amt) from orders where orders.ord_date = O.ord_date);

-- Count the customers with grades above Bangalore’s average. 
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

## library database project
create database library_db;
use library_db;
create table branch(
branch_id varchar(10) primary key,
manager_id varchar(10),
branch_address varchar(30),
contact_no varchar(15));
select * from branch;

##create table employees
create table employees(
emp_id varchar(10) primary key,
emp_name varchar(30),
position_ varchar(30),
salary int,
branch_id varchar(10) , ##fk
foreign key (branch_id) references branch(branch_id) );
select * from employees;

##create table members
create table members(
member_id varchar(10) primary key,
member_name varchar(30),
member_address varchar(30),
reg_date date );
select* from members;


##create table books
create table books(
isbn varchar(50) primary key,
book_title varchar(80),
category varchar(30),
rental_price int,
status_ varchar(10),
author varchar(30),
publisher varchar(80)
);
select * from books;

## create table return_status
create table return_status(
return_id varchar(10) primary key,
issued_id varchar(30),
return_book_name varchar(80), ##fk
return_date date,
return_book_isbn varchar(15),
foreign key (return_book_isbn) references books(isbn) );
select * from return_status;

## create table issue_status
create table issue_status(
issue_id varchar(10) primary key,
issued_member_id varchar(30), ##fk
issue_book_name varchar(50),
issue_date date,
issue_book_isbn varchar(50), ##fk
issued_emp_id varchar (10),  ##fk
foreign key (issued_member_id) references members(member_id),
foreign key (issue_book_isbn) references books(isbn),
foreign key (issued_emp_id) references employees(emp_id) );
select * from issue_status;

##CURD OPERATIONS


## task 1 creating new record
insert into books values ("978-1-60129-456-2", 
'To Kill a Mockingbird',
 'Classic', 6.00, 'yes',
 'Harper Lee',
 'J.B. Lippincott & Co.');

## task 2 Update an Existing Member's Address
update members 
set member_address ="Manu Marg"
where member_id = "c101";

##Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select issue_book_name from issue_status
where issued_emp_id= "E1O1";
## task 4 Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issue_status 
where issue_id = "IS121" ;

##Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT  issued_member_id ,COUNT(issued_member_id) FROM ISSUE_STATUS 
GROUP BY issued_member_id 
HAVING COUNT(issued_member_id) >=2  ;

##Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table issue_data as
select b.isbn,b.book_title, count(i.issue_book_isbn) as issue_count from 
books as b
 join issue_status as i
on b.isbn = i.issue_book_isbn
group by b.isbn,b.book_title;
select * from issue_data;
select count(issue_count) from issue_data;

##Task 7. Retrieve All Books in a Specific Category:
select book_title, category from books
group by book_title,category 
order by category asc ;

##Task 8: Find Total Rental Income by Category:
select b.category , sum(rental_price) , count(*) from books as b
join issue_status as i
on b.isbn = i.issue_book_isbn
group by b.category
;

##task 9 List Members Who Registered in the Last 180 Days:
select member_id , member_name 
from members 
where reg_date >= current_date()- interval 180 day ;

##task 10. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as
select book_title , rental_price from books 
where rental_price > 7;
select * from expensive_books;



-- ProgramConsider the following schema for a Library Database:
-- BOOK(Book_id, Title, Publisher_Name, Pub_Year)
-- BOOK_AUTHORS(Book_id, Author_Name)
-- PUBLISHER(Name, Address, Phone)
-- BOOK_COPIES(Book_id, Programme_id, No-of_Copies)
-- BOOK_LENDING(Book_id, Programme_id, Card_No, Date_Out, Due_Date)
-- LIBRARY_PROGRAMME(Programme_id, Programme_Name, Address)
--  Write SQL queries to
--  1. Retrieve details of all books in the library – id, title, name of publisher, authors, number of 
-- copies in each Programme, etc.
--  2. Get the particulars of borrowers who have borrowed more than 3 books, but
-- from Jan 2017 to Jun 2017.
--  3. Delete a book in BOOK table. Update the contents of other tables to reflect this
-- data manipulation operation.
--  4. Partition the BOOK table based on year of publication. Demonstrate its working
-- with a simple query.
--  5. Create a view of all books and its number of copies that are currently available in
-- the Library.

create database library;
-- Ctrl + Shift + Enter = execute the whole file
-- Ctrl + Enter = Execute selection / Execute the current line
use library;

create table publisher (
	name varchar(20) primary key,
    phone bigint(10,
    address varchar(20)
);

create table book (
	book_id int(6) primary key,
    title varchar(20),
    pub_name varchar(20),
    pub_year varchar(10),
    foreign key (pub_name) references publisher(name) on delete cascade
);

create table book_authors (
	author_name varchar(20),
    book_id int(6),
    foreign key (book_id) references book(book_id) on delete cascade,
    primary key(book_id, author_name)
);

create table library_branch (
	branch_id int primary key,
    branch_name varchar(50),
    address varchar (50)
);

create table book_copies (
	no_of_copies integer,
    book_id int,
    branch_id int,
    foreign key (book_id) references book(book_id) on delete cascade,
    foreign key (branch_id) references library_branch(branch_id) on delete cascade,
    primary key(book_id, branch_id)
);

create table card (
	card_no int primary key
);

create table book_lending (
	date_out date,
    due_date date,
    book_id int,
    branch_id int,
    card_no int,
    foreign key (book_id) references book(book_id) on delete cascade,
    foreign key (branch_id) references library_branch(branch_id) on delete cascade,
    foreign key (card_no) references card(card_no) on delete cascade,
    primary key(book_id, branch_id, card_no)
);
desc book_lending;
-- value insertion

INSERT INTO PUBLISHER VALUES    ('MCGRAW-HILL', 9989076587, 'BANGALORE'),
                                ('PEARSON', 9889076565, 'NEWDELHI'),
                                ('RANDOM HOUSE', 7455679345, 'HYDRABAD'),
                                ('HACHETTE LIVRE', 8970862340, 'CHENAI'),
                                ('GRUPO PLANETA', 7756120238, 'BANGALORE');
select * from publisher;

INSERT INTO BOOK VALUES     (1,'DBMS', 'MCGRAW-HILL','JAN-2017'),
                            (2,'ADBMS', 'MCGRAW-HILL','JUN-2016'),
                            (3,'CN', 'PEARSON','SEP-2016'),
                            (4,'CG', 'GRUPO PLANETA','SEP-2015'),
                            (5,'OS', 'PEARSON','MAY-2016');
select * from book;

INSERT INTO BOOK_AUTHORS VALUES ('NAVATHE', 1), 
                                ('NAVATHE', 2),
                                ('TANENBAUM', 3),
                                ('EDWARD ANGEL', 4),
                                ('GALVIN', 5);
select * from book_authors;

INSERT INTO LIBRARY_BRANCH VALUES   (10,'RR NAGAR','BANGALORE'),
                                    (11,'RNSIT','BANGALORE'),
                                    (12,'RAJAJI NAGAR', 'BANGALORE'),
                                    (13,'NITTE','MANGALORE'),
                                    (14,'MANIPAL','UDUPI');
select * from library_branch;

INSERT INTO BOOK_COPIES VALUES  (10, 1, 10),
                                (5, 1, 11),
                                (2, 2, 12),
                                (5, 2, 13),
                                (7, 3, 14),
                                (1, 5, 10),
                                (3, 4, 11);
select * from book_copies;

INSERT INTO CARD VALUES (100),
                        (101),
                        (102),
                        (103),
                        (104);
select * from card;

INSERT INTO BOOK_LENDING VALUES ('2017-01-01','2017-05-01', 1, 10, 101),
                                ('2017-01-11','2017-03-11', 3, 14, 101),
                                ('2017-02-21','2017-04-21', 2, 13, 101),
                                ('2017-03-15','2017-06-15', 4, 11, 101),
                                ('2017-04-12','2017-05-12', 1, 11, 104);
select * from book_lending;

-- QUERIES
-- QUERY 1
-- Retrieve details of all books in the library 
-- id, title, pub_name, author, number of copies in each branch 
-- BOOK, BOOK_AUTHOR, BOOK_COPIES, 
select b.book_id, b.title, b.pub_name, ba. author_name, bc.no_of_copies, bc.branch_id
from book b, book_authors ba, book_copies bc
where b.book_id = ba.book_id
and b.book_id = bc.book_id;

select b.book_id, b.title, b.pub_name, ba. author_name, bc.no_of_copies, bl.branch_id
from book b, book_authors ba, book_copies bc, book_lending bl
where b.book_id = ba.book_id
and b.book_id = bc.book_id
and bl.branch_id = bc.branch_id;
-- idk which one of the above is corrent and why

-- QUERY 2
-- Get the particulars of the borrowers who have borrowed more than 3 books 
-- from jan 2017 to jun 2017
select card_no 
from book_lending
where date_out between '2017-01-01' and '2017-06-01'
group by card_no
having count(*) > 3;

-- QUERY 3
-- on dellete cascade thingy

-- QUERY 4
-- partition the book table based on year ob publication 
select pub_year from book
group by pub_year
having pub_year like '%-20__';

-- QUERY 5
-- Create a view of all books and its number of copies that are 
-- currently avaliable in the Library 
create view book_copies_view as
select b.title, c.no_of_copies
from book b, book_copies c, library_branch l
where b.book_id = c.book_id
and c.branch_id = l.branch_id;

select * from book_copies_view;


create table actor (
	act_id int(3) primary key,
    act_name varchar(20),
    act_gender char(1)
);

create table director (
	dir_id int primary key,
    dir_name varchar(20),
    dir_phone bigint
);

create table movies (
	mov_id int primary key,
	mov_title varchar(25),
	mov_year int,
	mov_lang varchar(12),
	dir_id int,
    foreign key (dir_id) references director(dir_id)
);

create table movie_cast (
	act_id int,
    mov_id int,
    role varchar(10),
    primary key (act_id, mov_id),
    foreign key (act_id) references actor(act_id),
    foreign key (mov_id) references movies(mov_id)
);
desc movie_cast;
create table rating (
	mov_id int primary key,
    rev_stars varchar(25),
    foreign key (mov_id) references movies(mov_id)
);


-- VALUE INSERTION

insert into actor values	(301, 'ANUSHKA', 'F'),
							(302, 'PRABHAS', 'M'),
							(303, 'PUNITH', 'M'),
							(304, 'JERMY', 'M');

INSERT INTO DIRECTOR VALUES (60,'RAJAMOULI', 8751611001), 
							(61,'HITCHCOCK', 7766138911), 
							(62,'FARAN', 9986776531),
							(63,'STEVEN SPIELBERG', 8989776530);

INSERT INTO MOVIES VALUES 	(1001,'BAHUBALI-2', 2017, 'TELAGU', 60),
							(1002,'BAHUBALI-1', 2015, 'TELAGU', 60),
							(1003,'AKASH', 2008, 'KANNADA', 61),
							(1004,'WAR HORSE', 2011, 'ENGLISH', 63);

INSERT INTO MOVIE_CAST VALUES 	(301, 1002, 'HEROINE'),
								(301, 1001, 'HEROINE'),
								(303, 1003, 'HERO'),
								(303, 1002, 'GUEST'),
								(304, 1004, 'HERO');

INSERT INTO RATING VALUES 	(1001, 4),
							(1002, 2),
							(1003, 5),
							(1004, 4);

-- QUERY 1
select mov_title from movies 
where dir_id in (select dir_id from director where dir_name = 'HITCHCOCK');

-- QUERY 2
SELECT MOV_TITLE
FROM MOVIES M, MOVIE_CAST MV
WHERE M.MOV_ID=MV.MOV_ID AND ACT_ID 
IN (SELECT ACT_ID
FROM MOVIE_CAST GROUP BY ACT_ID 
HAVING COUNT(ACT_ID)>1)
GROUP BY MOV_TITLE 
HAVING count(*) > 1;

-- QUERY 3
SELECT ACT_NAME, MOV_TITLE, MOV_YEAR
FROM ACTOR A 
JOIN MOVIE_CAST C
ON A.ACT_ID=C.ACT_ID 
JOIN MOVIES M
ON C.MOV_ID=M.MOV_ID
WHERE M.MOV_YEAR NOT BETWEEN 2000 AND 2015; 
-- OR
SELECT A.ACT_NAME, A.ACT_NAME, C.MOV_TITLE, C.MOV_YEAR 
FROM ACTOR A, MOVIE_CAST B, MOVIES C
WHERE A.ACT_ID=B.ACT_ID 
AND B.MOV_ID=C.MOV_ID
AND C.MOV_YEAR NOT BETWEEN 2000 AND 2015;

-- QUERY 4
SELECT MOV_TITLE, MAX(REV_STARS) 
FROM MOVIES
INNER JOIN RATING USING (MOV_ID) 
GROUP BY MOV_TITLE
HAVING MAX(REV_STARS)>0 
ORDER BY MOV_TITLE;

-- QUERY 5
UPDATE RATING 
SET REV_STARS=5
WHERE MOV_ID IN (SELECT MOV_ID FROM MOVIES
WHERE DIR_ID IN (SELECT DIR_ID
FROM DIRECTOR
WHERE DIR_NAME = 'STEVEN 
SPIELBERG'));
select * from rating;

drop database movie;
create database movie;
use movie;
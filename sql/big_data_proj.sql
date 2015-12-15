use projects;

show tables from projects;

show columns from geo_positive;

CREATE TABLE IF NOT EXISTS geo_positive(

	contestant 		varchar(80),
    user_location 	varchar(120),
	create_date		char(10),
    count			bigint(20),
    constraint pk PRIMARY KEY(contestant, user_location, create_date) 
    
);

CREATE TABLE IF NOT EXISTS geo_negative(

	contestant 		varchar(80),
    user_location 	varchar(120),
	create_date		char(10),
    count			bigint(20),
    constraint pk PRIMARY KEY(contestant, user_location, create_date) 
);

CREATE TABLE IF NOT EXISTS geo_neutral(
	contestant 		varchar(80),
    user_location 	varchar(120),
	create_date		char(10),
    count			bigint(20),
    constraint pk PRIMARY KEY(contestant, user_location, create_date) 
);

CREATE TABLE IF NOT EXISTS geo_total(
	contestant 		varchar(80),
    user_location 	varchar(120),
	create_date		char(10),
    count			bigint(20),
    constraint pk PRIMARY KEY(contestant, user_location, create_date)
);

CREATE TABLE IF NOT EXISTS temporal(
	contestant 		varchar(80),
	create_date		char(10),
	create_hour		char(2),
    sentiment		char(20),
    count			bigint(20),
    constraint pk PRIMARY KEY(contestant, create_date, create_hour, sentiment)
);

-- drop table geo_positive;
-- drop table geo_negative;
-- drop table geo_neutral;
-- drop table geo_total;

-- drop table temporal;

select * from geo_total;

select * from geo_positive;
select * from geo_negative;
select * from geo_total;
select * from temporal;

select count(*) from geo_positive;
select count(*) from geo_negative;
select count(*) from geo_total;

select count(*) from temporal;


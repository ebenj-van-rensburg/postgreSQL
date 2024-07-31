CREATE TABLE peeps (
    name_column varchar(25),
    age_column real,
	birthday_column date,
	hair_column varchar(15),
	eye_column varchar(15)
);

COPY peeps 
FROM 'D:\bootcamp\SQL\myCode\Chapter4\COPY_TEST.csv'
WITH (FORMAT CSV, HEADER);

SELECT * FROM peeps;
CREATE TABLE date_time_types (
    timestamp_column timestamp with time zone,
    interval_column interval
);

INSERT INTO date_time_types 
VALUES 
    ('2018-12-31 01:00 EST','2 days'),
    ('2018-12-31 01:00 -8','1 month'),
    ('2018-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week');

SELECT * FROM date_time_types;

SELECT 
    timestamp_column, 
    interval_column, 
    timestamp_column - interval_column AS new_date
FROM date_time_types;


-- • A Boolean type that stores a value of true or false
-- • Geometric types that include points, lines, circles, and other two-
-- dimensional objects
-- • Network address types, such as IP or MAC addresses
-- • A Universally Unique Identifier (UUID) type, sometimes used as a 
-- unique key value in tables
-- • XML and JSON data types that store information in those structured 
-- formats
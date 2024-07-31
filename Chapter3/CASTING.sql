SELECT timestamp_column, CAST(timestamp_column AS varchar(10))
FROM date_time_types;
-- CAST :: shorcut notation
SELECT timestamp_column::varchar(10) 
FROM date_time_types;

SELECT numeric_column, 
       CAST(numeric_column AS integer), 
       CAST(numeric_column AS varchar(6)) 
FROM number_data_types; 

-- will not work, char has no int cast
SELECT CAST(char_column AS integer) FROM char_data_types;
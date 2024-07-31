COPY us_counties_2010
TO 'D:\admin\ObsidianVault\CodeCollege\Bootcamp\postgreSQL\CSV\us_counties_export.md'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

COPY (
    SELECT geo_name, state_us_abbreviation 
    FROM us_counties_2010 
    WHERE geo_name ILIKE '%mill%'
     )
TO 'D:\admin\ObsidianVault\CodeCollege\Bootcamp\postgreSQL\CSV\us_counties_mill_export.md'
WITH (FORMAT CSV, HEADER, DELIMITER '|');
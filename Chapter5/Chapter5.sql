-- Listing 5-1: Basic addition, subtraction and multiplication with SQL
SELECT 2 + 2;
SELECT 9 - 1;
SELECT 3 * 4;

-- Listing 5-2: Integer and decimal division with SQL
SELECT 11 / 6;
SELECT 11 % 6;
SELECT 11.0 / 6;
SELECT CAST(11 AS numeric(3,1)) / 6;

-- Listing 5-3: Exponents, roots and factorials with SQL
SELECT 3 ^ 4;
SELECT |/ 10;
SELECT sqrt(10);
SELECT ||/ 10;
SELECT factorial(4);
-- Order of operations
SELECT 7 + 8 * 9;
SELECT (7 + 8) * 9;
SELECT 3 ^ 3 - 1;
SELECT 3 ^ (3 - 1);

-- Listing 5-4: Selecting Census population columns by race with aliases
SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total Population",
       p0010003 AS "White Alone",
       p0010004 AS "Black or African American Alone",
       p0010005 AS "Am Indian/Alaska Native Alone",
       p0010006 AS "Asian Alone",
       p0010007 AS "Native Hawaiian and Other Pacific Islander Alone",
       p0010008 AS "Some Other Race Alone",
       p0010009 AS "Two or More Races"
FROM us_counties_2010;

-- Listing 5-5: Adding two columns in us_counties_2010
SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010003 AS "White Alone",
       p0010004 AS "Black Alone",
       p0010003 + p0010004 AS "Total White and Black"
FROM us_counties_2010;

-- Listing 5-6: Checking Census data totals
SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total",
       p0010003 + p0010004 + p0010005 + p0010006 + p0010007
           + p0010008 + p0010009 AS "All Races",
       (p0010003 + p0010004 + p0010005 + p0010006 + p0010007
           + p0010008 + p0010009) - p0010001 AS "Difference" -- should return 0
FROM us_counties_2010
ORDER BY "Difference" DESC;

-- Listing 5-7: Calculating the percent of the population that is Asian by county (percent of the whole)
SELECT geo_name,
       state_us_abbreviation AS "st",
       (CAST(p0010006 AS numeric(8,1)) / p0010001) * 100 AS "pct_asian"  -- calculate percentage of total
FROM us_counties_2010
ORDER BY "pct_asian" DESC;

-- Listing 5-8: Calculating percent change
CREATE TABLE percent_change (
    department varchar(20),
    spend_2014 numeric(10,2),
    spend_2017 numeric(10,2)
);

INSERT INTO percent_change
VALUES
    ('Building', 250000, 289000),
    ('Assessor', 178556, 179500),
    ('Library', 87777, 90001),
    ('Clerk', 451980, 650000),
    ('Police', 250000, 223000),
    ('Recreation', 199000, 195000);

SELECT department,
       spend_2014,
       spend_2017,
       round( (spend_2017 - spend_2014) /
                    spend_2014 * 100, 1 ) AS "pct_change" -- percent change formula (apply day-by-day, q-by-q or any equal measure)
FROM percent_change;

-- Listing 5-9: Using sum() and avg() aggregate functions
SELECT sum(p0010001) AS "County Sum", -- returns sum of all rows added
       round(avg(p0010001), 0) AS "County Average" -- returns average of all rows added
FROM us_counties_2010;

-- Listing 5-10: Testing SQL percentile functions
CREATE TABLE percentile_test (
    numbers integer
);

INSERT INTO percentile_test (numbers)
VALUES
    (1), (2), (3), (4), (5), (6);

SELECT
    percentile_cont(.5) -- used for actual medians
    WITHIN GROUP (ORDER BY numbers),
    percentile_disc(.5) -- takes last value in the first 50% of values
    WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;

-- Listing 5-11: Using sum(), avg(), and percentile_cont() aggregate functions
SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average", -- averages can be off or misleading
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY p0010001) AS "County Median" -- chad median values
FROM us_counties_2010;

-- Listing 5-12: Passing an array of values to percentile_cont()
-- quartiles
SELECT percentile_cont(array[.25,.5,.75]) -- settting the percentile to calc for quartiles
       WITHIN GROUP (ORDER BY p0010001) AS "quartiles"
FROM us_counties_2010;
-- quintiles
SELECT percentile_cont(array[.2,.4,.6,.8]) -- every 20th (even go brrr)
       WITHIN GROUP (ORDER BY p0010001) AS "quintiles"
FROM us_counties_2010;
-- deciles
SELECT percentile_cont(array[.1,.2,.3,.4,.5,.6,.7,.8,.9]) -- every 10th
       WITHIN GROUP (ORDER BY p0010001) AS "deciles"
FROM us_counties_2010;

-- Listing 5-13: Using unnest() to turn an array into rows
SELECT unnest( -- destructs and arry into rows
            percentile_cont(array[.25,.5,.75])
            WITHIN GROUP (ORDER BY p0010001)
            ) AS "quartiles"
FROM us_counties_2010;

-- Listing 5-14: Creating a median() aggregate function in PostgreSQL
CREATE OR REPLACE FUNCTION _final_median(anyarray)
RETURNS float8 AS
$$
WITH q AS (
  SELECT unnest($1) AS val
),
sorted_q AS (
  SELECT val
  FROM q
  WHERE val IS NOT NULL
  ORDER BY val
),
cnt AS (
  SELECT COUNT(*) AS c
  FROM sorted_q
)
SELECT AVG(val)::float8
FROM (
  SELECT val
  FROM sorted_q
  OFFSET GREATEST((SELECT (c - 1) / 2 FROM cnt), 0)
  FETCH FIRST (SELECT 1 + (1 - c % 2) FROM cnt) ROWS ONLY
) sub;
$$
LANGUAGE SQL IMMUTABLE;

CREATE AGGREGATE median(float8) (
  SFUNC = array_append,
  STYPE = float8[],
  FINALFUNC = _final_median,
  INITCOND = '{}'
);

-- Listing 5-15: Using a median() aggregate function
SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average",
       median(p0010001) AS "County Median", -- self-created median array function
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY P0010001) AS "50th Percentile"
FROM us_counties_2010;

-- Listing 5-16: Finding the most-frequent value with mode()
SELECT mode() WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010;
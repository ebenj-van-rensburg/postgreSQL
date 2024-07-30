-- Case sensitive
-- SELECT first_name
-- FROM teachers
-- WHERE first_name LIKE 'sam%';

-- Case insensitive
SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';
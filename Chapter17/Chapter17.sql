-- Listing 17-1: Creating a table to test vacuuming
CREATE TABLE vacuum_test (
    integer_column integer
);

-- Listing 17-2: Determining the size of vacuum_test
SELECT pg_size_pretty(
           pg_total_relation_size('vacuum_test')
       );
-- determine database size   
SELECT pg_size_pretty(
           pg_database_size('Analysis')
       );

-- Listing 17-3: Inserting 500,000 rows into vacuum_test
INSERT INTO vacuum_test
SELECT * FROM generate_series(1,500000);
-- test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-4: Updating all rows in vacuum_test
UPDATE vacuum_test
SET integer_column = integer_column + 1;
-- test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-5: Viewing autovacuum statistics for vacuum_test
SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';
-- to see all columns available
SELECT *
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- Listing 17-6: Running VACUUM manually
VACUUM vacuum_test;
VACUUM; -- vacuums the whole database
VACUUM VERBOSE; -- provides messages

-- Listing 17-7: Using VACUUM FULL to reclaim disk space
VACUUM FULL vacuum_test;
-- test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-8: Showing the location of postgresql.conf
SHOW config_file;

-- Listing 17-10: Show the location of the data directory
SHOW data_directory;
-- reload settings - Windows: pg_ctl reload -D "C:\Program Files\PostgreSQL\16\data"

-- Listing 17-11: Backing up the analysis database with pg_dump
pg_dump -d Analysis -U [user_name] -Fc > Analysis_backup.sql;
-- back up just a table
pg_dump -t 'train_rides' -d Analysis -U [user_name] -Fc > train_backup.sql 

-- Listing 17-12: Restoring the analysis database with pg_restore
pg_restore -C -d postgres -U postgres Analysis_backup_custom.sql

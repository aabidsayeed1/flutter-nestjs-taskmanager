      
============================================How to run this project???=======================================================


1. connect database uat or qa
2. change below threshold value according to project need
const POOL_SIZE = process.env.PERFORMANCE_POOL_SIZE || '';
const MAX_ROWS = process.env.PERFORMANCE_MAX_ROWS || '';
const MAX_COST = process.env.PERFORMANCE_MAX_COST || '';

3. Run performance.script.ts script ==========>  npx ts-node -r tsconfig-paths/register src/performance/performance.script.ts
output : it will generate few json file under performance-json folder

4. Run json-to-html.script.ts script ========> npx ts-node -r tsconfig-paths/register src/performance/json-to-html.script.ts 
output : reports.html

Note : If someone want to run script locally on docker so we need to do follow below steps: 

1. create postgres.conf file if not exists and add these lines :

# Connection Settings
listen_addresses = '*'
port = 5432

# Enable pg_stat_statements
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.track = all
pg_stat_statements.max = 10000
pg_stat_statements.initialization_mode = 'auto'

2. mount postgres.conf file path in docker-compose.yml
3. restart the project




=====================================Reason why we created this===================================================================================

we can catch below issues in lower environments (Say Dev, QA, UAT,...)

1. Lack of proper index or missing composite index
2. Using ilike operator with %term
3. Query usage causes heavy
4. Where clauses are not indexed
5. We have low amount data in lower env but production has higher data size.


1. Ensure pg_stat_statements extension is enabled.
2. Ensure we have right connection pool size
3. VACUUM(FULL, ANALYZE);
5. Ordering of where clause with index ordering matters (especially in composite index)
6. We are using UUID7 and not UUID4
7. Run EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) against each query in the query logged.
  - Check the cost and if it crosses certian threshold (configurable), show as red
  - Check for any table scan or seq scan. If any, mark them as red.
  - Check if rows acceessed is larger then say 1000, then mark as red.
8. If enabled in config, every typeorm query should run with 'EXPLAIN ...'


===========================List of queries which we run  and save the result========================================================
 
1. when was the last time vacuum command executed
SELECT schemaname,relname as table_name, last_vacuum, last_analyze, last_autovacuum, last_autoanalyze, n_live_tup,n_dead_tup from pg_stat_user_tables;

2. list all foreign key constraints in the database that do not have an index on the source columns 
    SELECT c.conrelid::regclass AS "table",
           /* list of key column names in order */
           string_agg(a.attname, ',' ORDER BY x.n) AS columns,
           pg_catalog.pg_size_pretty(
              pg_catalog.pg_relation_size(c.conrelid)
           ) AS size,
           c.conname AS constraint,
           c.confrelid::regclass AS referenced_table
    FROM pg_catalog.pg_constraint c
       /* enumerated key column numbers per foreign key */
       CROSS JOIN LATERAL
          unnest(c.conkey) WITH ORDINALITY AS x(attnum, n)
       /* name for each key column */
       JOIN pg_catalog.pg_attribute a
          ON a.attnum = x.attnum
             AND a.attrelid = c.conrelid
    WHERE NOT EXISTS
            /* is there a matching index for the constraint? */
            (SELECT 1 FROM pg_catalog.pg_index i
             WHERE i.indrelid = c.conrelid
               /* it must not be a partial index */
               AND i.indpred IS NULL
               /* the first index columns must be the same as the
                  key columns, but order doesn't matter */
               AND (i.indkey::smallint[])[0:cardinality(c.conkey)-1]
                   OPERATOR(pg_catalog.@>) c.conkey)
      AND c.contype = 'f'
    GROUP BY c.conrelid, c.conname, c.confrelid
    ORDER BY pg_catalog.pg_relation_size(c.conrelid) DESC;


3. find the indexes that have never been used since the last statistics reset with pg_stat_reset() 
    -- You can replace s.idx_scan = 0 in the query with a different condition, e.g. s.idx_scan < 10. Indexes that are very rarely used are also good candidates for removal. 
    SELECT s.schemaname,
           s.relname AS tablename,
           s.indexrelname AS indexname,
           pg_relation_size(s.indexrelid) AS index_size
    FROM pg_catalog.pg_stat_user_indexes s
       JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
    WHERE s.idx_scan = 0      -- has never been scanned
      AND 0 <>ALL (i.indkey)  -- no index column is an expression
      AND NOT i.indisunique   -- is not a UNIQUE index
      AND NOT EXISTS          -- does not enforce a constraint
             (SELECT 1 FROM pg_catalog.pg_constraint c
              WHERE c.conindid = s.indexrelid)
      AND NOT EXISTS          -- is not an index partition
             (SELECT 1 FROM pg_catalog.pg_inherits AS inh
              WHERE inh.inhrelid = s.indexrelid)
    ORDER BY pg_relation_size(s.indexrelid) DESC;

4. returns those tables which have been hit by sequential scans the most and tells us how many rows a sequential scan has hit on average  

    SELECT schemaname, 
                  relname, 
                  seq_scan, 
                  seq_tup_read, 
                  idx_scan, 
                  seq_tup_read / seq_scan AS avg
     FROM         pg_stat_user_tables 
     WHERE        seq_scan > 0 
     ORDER BY     seq_tup_read DESC;

5. Slow queries 
     SELECT query, 
              total_exec_time, 
              calls, 
              mean_exec_time 
       FROM   pg_stat_statements 
       ORDER BY total_exec_time DESC; 

6. High CPU/IO load
     SELECT queryid, 
              query, 
              calls, 
              mean_time,
              shared_blks_hit
       FROM   pg_stat_statements 
       ORDER BY shared_blks_hit DESC; 

7. Slow avg queries  
     SELECT query, 
              total_exec_time, 
              calls, 
              mean_exec_time 
       FROM   pg_stat_statements 
       ORDER BY mean_exec_time DESC;
       
       
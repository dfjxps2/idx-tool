set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict; 
SET hive.exec.max.dynamic.partitions=100000;
SET hive.exec.max.dynamic.partitions.pernode=100000;

use indexdb;


-- drop table t1;
-- 
 CREATE TABLE `t1`(
   `data_year` string, 
   `zone_cd` string, 
   `dim_cd` string, 
   `value` string, 
   `year_last_year_pct` string)
 ROW FORMAT SERDE 
   'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
 STORED AS INPUTFORMAT 
   'org.apache.hadoop.mapred.TextInputFormat' 
 OUTPUTFORMAT 
   'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
 LOCATION
   'hdfs://localhost:9000/user/hive/warehouse/indexdb.db/t1'
 TBLPROPERTIES (
   'transient_lastDdlTime'='1540620035')
 ;

insert into t1 values ('2001', '01', 'A00001', '1000', '1.10');
insert into t1 values ('2002', '01', 'A00001', '1200', '1.10');
insert into t1 values ('2001', '02', 'A00001', '1500', '1.10');

-- truncate table b04_base_data_tbl;
-- 
-- from (select * from t1) as src_tbl
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id)
-- select 'DS0106140000', data_year, zone_cd, dim_cd, value, concat(dim_cd, '01')
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id)
-- select 'DS0106140000', data_year, zone_cd, dim_cd, year_last_year_pct, concat(dim_cd, '02')
-- ;

-- from (
-- select * from t1
-- ) as src_tbl
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id)
-- select 'DS0103010000', data_year, zone_cd, dim_cd, value, dim_cd
-- ;

-- select * from b04_base_data_tbl;

quit;



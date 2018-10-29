use indexdb;

-- drop table t2;
-- 
 CREATE TABLE `t2`(
   `data_year` string, 
   `zone_cd` string, 
   `dim_cd` string 
 ,investment_fixed_assets_whole_society string
 ,wsfai_urban_fixed_assets_investment string
 ,wsfai_ufai_real_estate_development_investment string
 ,tsifa_rural_investment_fixed_assets string
 ,tsifa_infrastructure_investment string
 ,investment_fixed_assets_construction_and_installation string
 ,newly_added_fixed_assets string
 ,fixed_asset_investment_whole_society_increased_over_previous_yea string
 ,investment_fixed_assets_urban_areas_increased_from_previous_year string
 ,real_estate_development_investment string
 ,investment_rural_fixed_assets string
 ,infrastructure_investment string
 ,construction_and_installation_investment string
 )
 ROW FORMAT SERDE 
   'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
 STORED AS INPUTFORMAT 
   'org.apache.hadoop.mapred.TextInputFormat' 
 OUTPUTFORMAT 
   'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
 ;
 
 insert into t2 values ('2000', '01', 'B00001' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000');
 insert into t2 values ('2002', '02', 'B00001' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000');
 insert into t2 values ('2003', '03', 'B00001' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000');
 insert into t2 values ('2004', '01', 'B00001' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000' , '1000');
 

-- truncate table b04_base_data_tbl;
-- 
-- from (select * from t2 ) as src_tbl
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010001')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, investment_fixed_assets_whole_society
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010002')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, wsfai_urban_fixed_assets_investment
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010003')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, wsfai_ufai_real_estate_development_investment
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010004')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, tsifa_rural_investment_fixed_assets
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010005')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, tsifa_infrastructure_investment
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010006')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, investment_fixed_assets_construction_and_installation
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010007')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, newly_added_fixed_assets
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010008')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, fixed_asset_investment_whole_society_increased_over_previous_yea
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010009')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, investment_fixed_assets_urban_areas_increased_from_previous_year
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010010')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, real_estate_development_investment
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010011')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, investment_rural_fixed_assets
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010012')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, infrastructure_investment
-- insert into table indexdb.b04_base_data_tbl partition (data_col_catg='06', ind_id='I0106010013')
-- select 'DS0106010000', data_year, zone_cd, dim_cd, construction_and_installation_investment
-- ;

quit;


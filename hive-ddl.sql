--hive建表语句

--全社会固定资产投资和增长速度情况(亿元)(1978-当年)
create table historydb.h_bj30_stat_c_06_01(
id                      int                                                         COMMENT '主键ID'
,stat_year               string                                                     COMMENT '统计年份'
,data_year               string                                                     COMMENT '数据年份'
,investment_fixed_assets_whole_society   string                                     COMMENT '全社会固定资产投资'
,wsfai_urban_fixed_assets_investment     string                                     COMMENT '全社会固定资产投资-城镇固定资产投资'
,wsfai_ufai_real_estate_development_investment   string                             COMMENT '全社会固定资产投资-城镇固定资产投资-房地产开发投资'
,tsifa_rural_investment_fixed_assets     string                                     COMMENT '全社会固定资产投资-农村固定资产投资'
,tsifa_infrastructure_investment string                                             COMMENT '全社会固定资产投资-基础设施投资'
,investment_fixed_assets_construction_and_installation   string                     COMMENT '全社会固定资产投资-建筑安装投资'
,newly_added_fixed_assets        string                                             COMMENT '新增固定资产'
,fixed_asset_investment_whole_society_increased_over_previous_yea        string     COMMENT '全社会固定资产投资比上年增长'
,investment_fixed_assets_urban_areas_increased_from_previous_year        string     COMMENT '全社会固定资产投资比上年增长-城镇固定资产投资'
,real_estate_development_investment      string                                     COMMENT '房地产开发投资'
,investment_rural_fixed_assets   string                                             COMMENT '农村固定资产投资'
,infrastructure_investment       string                                             COMMENT '基础设施投资'
,construction_and_installation_investment        string                             COMMENT '建筑安装投资'
,jdrx_update_time        bigint                                                     COMMENT '汇聚时间'
) COMMENT '全社会固定资产投资和增长速度情况(亿元)(1978-当年)'
PARTITIONED BY (`access_partition_year` string,  `access_partition_month` string, `access_partition_day` string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


--保障性安居工程建设情况(亿元、万平方米)
create table historydb.h_bj30_stat_c_06_14(
id                      int                      COMMENT '主键ID'
,stat_year               string                  COMMENT '统计年份'
,data_year               string                  COMMENT '数据年份'
,item                    string                  COMMENT '项目'
,unit                    string                  COMMENT '单位'
,value                   string                  COMMENT '值'
,year_last_year_pct      string                  COMMENT '当年为去年占比'
,jdrx_update_time        bigint                  COMMENT '汇聚时间'
) COMMENT '保障性安居工程建设情况(亿元、万平方米)'
PARTITIONED BY (`access_partition_year` string,  `access_partition_month` string, `access_partition_day` string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

--六次人口普查人口基本情况
create table historydb.h_bj30_stat_c_03_01(
stat_year               string                   COMMENT '年鉴'
,data_year               string                   COMMENT '年份'
,item                    string                   COMMENT '项目'
,unit                    string                   COMMENT '单位'
,value                   string                   COMMENT '值'
) COMMENT '六次人口普查人口基本情况'
PARTITIONED BY (`access_partition_year` string,  `access_partition_month` string, `access_partition_day` string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


--分析维度映射表
CREATE TABLE basedb.B99_ADIM_MAP
(
Data_Col_Src_Tbl      STRING  COMMENT '数据集来源表'
,Adim_Id              INT  COMMENT '分析维度编号'
,Src_Adim_Nm          STRING COMMENT '源分析维度名称'
,Target_Adim_Nm       STRING COMMENT '目标分析维度名称'
,Adim_Ind_Id          STRING COMMENT '分析维度指标编号'
) COMMENT '分析维度映射表'
PARTITIONED BY (Subject string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;



--接口数据集表
CREATE TABLE indexdb.B04_BASE_DATA_TBL
(
Data_Col_Id     STRING         COMMENT '数据集编号'
,Data_Col_Catg  STRING         COMMENT '数据集类别'
,Data_Cycle     STRING         COMMENT '数据周期'
,Region_Cd      STRING         COMMENT '区域代码'
,Dim_Cd         STRING         COMMENT '维度代码'
,Ind_Val        DECIMAL(18,2)  COMMENT '指标值'
) COMMENT '基础数据表'
PARTITIONED BY (Subject string, Ind_Id string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

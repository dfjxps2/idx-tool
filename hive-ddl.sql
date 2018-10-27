--hive�������

--ȫ���̶��ʲ�Ͷ�ʺ������ٶ����(��Ԫ)(1978-����)
create table historydb.h_bj30_stat_c_06_01(
id                      int                                                         COMMENT '����ID'
,stat_year               string                                                     COMMENT 'ͳ�����'
,data_year               string                                                     COMMENT '�������'
,investment_fixed_assets_whole_society   string                                     COMMENT 'ȫ���̶��ʲ�Ͷ��'
,wsfai_urban_fixed_assets_investment     string                                     COMMENT 'ȫ���̶��ʲ�Ͷ��-����̶��ʲ�Ͷ��'
,wsfai_ufai_real_estate_development_investment   string                             COMMENT 'ȫ���̶��ʲ�Ͷ��-����̶��ʲ�Ͷ��-���ز�����Ͷ��'
,tsifa_rural_investment_fixed_assets     string                                     COMMENT 'ȫ���̶��ʲ�Ͷ��-ũ��̶��ʲ�Ͷ��'
,tsifa_infrastructure_investment string                                             COMMENT 'ȫ���̶��ʲ�Ͷ��-������ʩͶ��'
,investment_fixed_assets_construction_and_installation   string                     COMMENT 'ȫ���̶��ʲ�Ͷ��-������װͶ��'
,newly_added_fixed_assets        string                                             COMMENT '�����̶��ʲ�'
,fixed_asset_investment_whole_society_increased_over_previous_yea        string     COMMENT 'ȫ���̶��ʲ�Ͷ�ʱ���������'
,investment_fixed_assets_urban_areas_increased_from_previous_year        string     COMMENT 'ȫ���̶��ʲ�Ͷ�ʱ���������-����̶��ʲ�Ͷ��'
,real_estate_development_investment      string                                     COMMENT '���ز�����Ͷ��'
,investment_rural_fixed_assets   string                                             COMMENT 'ũ��̶��ʲ�Ͷ��'
,infrastructure_investment       string                                             COMMENT '������ʩͶ��'
,construction_and_installation_investment        string                             COMMENT '������װͶ��'
,jdrx_update_time        bigint                                                     COMMENT '���ʱ��'
) COMMENT 'ȫ���̶��ʲ�Ͷ�ʺ������ٶ����(��Ԫ)(1978-����)'
PARTITIONED BY (`access_partition_year` string,  `access_partition_month` string, `access_partition_day` string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


--�����԰��ӹ��̽������(��Ԫ����ƽ����)
create table historydb.h_bj30_stat_c_06_14(
id                      int                      COMMENT '����ID'
,stat_year               string                  COMMENT 'ͳ�����'
,data_year               string                  COMMENT '�������'
,item                    string                  COMMENT '��Ŀ'
,unit                    string                  COMMENT '��λ'
,value                   string                  COMMENT 'ֵ'
,year_last_year_pct      string                  COMMENT '����Ϊȥ��ռ��'
,jdrx_update_time        bigint                  COMMENT '���ʱ��'
) COMMENT '�����԰��ӹ��̽������(��Ԫ����ƽ����)'
PARTITIONED BY (`access_partition_year` string,  `access_partition_month` string, `access_partition_day` string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

--�����˿��ղ��˿ڻ������
create table historydb.h_bj30_stat_c_03_01(
stat_year               string                   COMMENT '���'
,data_year               string                   COMMENT '���'
,item                    string                   COMMENT '��Ŀ'
,unit                    string                   COMMENT '��λ'
,value                   string                   COMMENT 'ֵ'
) COMMENT '�����˿��ղ��˿ڻ������'
PARTITIONED BY (`access_partition_year` string,  `access_partition_month` string, `access_partition_day` string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


--����ά��ӳ���
CREATE TABLE basedb.B99_ADIM_MAP
(
Data_Col_Src_Tbl      STRING  COMMENT '���ݼ���Դ��'
,Adim_Id              INT  COMMENT '����ά�ȱ��'
,Src_Adim_Nm          STRING COMMENT 'Դ����ά������'
,Target_Adim_Nm       STRING COMMENT 'Ŀ�����ά������'
,Adim_Ind_Id          STRING COMMENT '����ά��ָ����'
) COMMENT '����ά��ӳ���'
PARTITIONED BY (Subject string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;



--�ӿ����ݼ���
CREATE TABLE indexdb.B04_BASE_DATA_TBL
(
Data_Col_Id     STRING         COMMENT '���ݼ����'
,Data_Col_Catg  STRING         COMMENT '���ݼ����'
,Data_Cycle     STRING         COMMENT '��������'
,Region_Cd      STRING         COMMENT '�������'
,Dim_Cd         STRING         COMMENT 'ά�ȴ���'
,Ind_Val        DECIMAL(18,2)  COMMENT 'ָ��ֵ'
) COMMENT '�������ݱ�'
PARTITIONED BY (Subject string, Ind_Id string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

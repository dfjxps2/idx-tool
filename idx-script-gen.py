import logging
import mysql.connector
from mysql_utils import MySQLUtils

conn = None
idx_dbname = None
idx_tablename = None
idx_subject = None


def get_data_collection_def():
    cursor = conn.cursor()

    sql = 'select * from idxcfg.b04_data_col'

    cursor.execute(sql)

    rs = MySQLUtils.get_rs_as_dict(cursor)

    for r in rs:
        for k in r.keys():
            print('%s:%s' % (k, r[k]))

    cursor.close()
    return rs


def get_index_def(dcId):
    cursor = conn.cursor()

    sql = 'select * from idxcfg.b04_ind_cfg where data_col_id = %s order by fld_id'

    cursor.execute(sql, dcId)

    rs = MySQLUtils.get_rs_as_dict(cursor)

    return rs


def gen_script_for_alg_1(dc_def):
    print('Generating script for {} using algorithm 1'.format(dc_def['Data_Col_Id']))

    dc_field_defs = get_index_def(dc_def['Data_Col_Id'])

    idx_fields = list(filter(lambda x: x['Ind_Id'] is not None and x['Ind_Id'] != '', dc_field_defs))

    script = 'from (%s) as src_tbl ' % dc_def['Data_Colsql']

    for idx_field in idx_fields:
        script += 'insert into table {tablename} partiton (subject={subject}) '.format(
            tablename=idx_tablename,
            subject=idx_subject)
        script += 'select {data_col_id}, {data_col_catg}, {data_cycle}, ' \
                  '{region_cd}, {dim_cd}, {ind_id}, {ind_val}'.format(
            data_col_id=idx_field['Data_Col_Id'],
            data_col_catg=dc_def['Data_Col_Catg'],
            data_cycle=list(filter(
                lambda x: x['Iba_Fld_Nm'] == 'data_cycle',
                dc_field_defs))[0]['Fld_En_Nm'],
            region_cd=list(filter(
                lambda x: x['Iba_Fld_Nm'] == 'region_cd',
                dc_field_defs))[0]['Fld_En_Nm'],
            dim_cd=list(
                filter(lambda x: x['Iba_Fld_Nm'] == 'dim_cd',
                       dc_field_defs))[0]['Fld_En_Nm'],
            ind_id=idx_field['Ind_Id'],
            ind_val=idx_field['Fld_En_Nm']
        )


def gen_script_for_alg_2(dc):
    print('Generating script for {} using algorithm 2'.format(dc['Data_Col_Id']))
    pass


def gen_script_for_alg_3(dc):
    print('Generating script for {} using algorithm 3'.format(dc['Data_Col_Id']))
    pass


generators = {
    'ALG001': gen_script_for_alg_1,
    'ALG002': gen_script_for_alg_2,
    'ALG003': gen_script_for_alg_3
}

if __name__ == '__main__':
    logging.basicConfig(filename='idx-tool.log', filemode='w', level=logging.DEBUG)

    logging.info('Program started.')

    conn = mysql.connector.connect(host='localhost', port=3306,
                                   user='root',
                                   passwd='root',
                                   charset='utf8')

    data_col_def = get_data_collection_def()

    for dc in data_col_def:
        generators[dc['Algor_Type']](dc)

    conn.close()

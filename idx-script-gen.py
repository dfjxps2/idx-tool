# -*- coding: utf-8 -*-
import os
import logging
import mysql.connector
import configparser
import io
from mysql_utils import MySQLUtils
from operator import itemgetter
from itertools import groupby

conn = None
idx_dbname = None
idx_tablename = None


def get_data_collection_def():
    cursor = conn.cursor()

    sql = 'select * from idxcfg.b04_data_col'

    cursor.execute(sql)

    rs = MySQLUtils.get_rs_as_dict(cursor)

    # for r in rs:
    #     for k in r.keys():
    #         print('%s:%s' % (k, r[k]))

    cursor.close()
    return rs


def get_index_def(dcId):
    cursor = conn.cursor()

    sql = 'select * from idxcfg.b04_ind_cfg where data_col_id = %s order by fld_id'

    cursor.execute(sql, (dcId,))

    rs = MySQLUtils.get_rs_as_dict(cursor)

    return rs


def gen_script_for_alg_1(dc_def):
    logging.debug('Generating script for {} using algorithm 1'.format(dc_def['Data_Col_Id']))

    dc_field_defs = get_index_def(dc_def['Data_Col_Id'])

    idx_fields = list(filter(lambda x: x['Ind_Id'] is not None and x['Ind_Id'] != '', dc_field_defs))
    idx_fields.sort(key=itemgetter('Ind_Id'))

    idx_group_lst = groupby(idx_fields, itemgetter('Ind_Id'))

    script = '\nfrom (%s) as src_tbl\n' % dc_def['Data_Colsql'].rstrip(' ;\n\r')

    for ind_id, group in idx_group_lst:
        field_list = list(group)

        if len(field_list) == 1:
            ind_val = field_list[0]['Fld_En_Nm']
        else:
            ind_val = 'coalesce({}, 0)'.format(field_list[0]['Fld_En_Nm'])
            for i in range(1, len(field_list)):
                ind_val += '+coalesce({}, 0)'.format(field_list[i]['Fld_En_Nm'])

        script += "insert overwrite table {dbname}.{tablename} " \
                  "partition (data_col_catg='{data_col_catg}', data_col_id='{data_col_id}', ind_id='{ind_id}')\n".format(
            dbname=idx_dbname,
            tablename=idx_tablename,
            data_col_catg=dc_def['Data_Col_Catg'],
            data_col_id=dc_def['Data_Col_Id'],
            ind_id=ind_id)

        script += "select {data_cycle}, " \
                  "{region_cd}, {dim_cd}, {ind_val}\n".format(
            data_cycle=list(filter(
                lambda x: x['Iba_Fld_Nm'] == 'data_cycle',
                dc_field_defs))[0]['Fld_En_Nm'],
            region_cd=list(filter(
                lambda x: x['Iba_Fld_Nm'] == 'region_cd',
                dc_field_defs))[0]['Fld_En_Nm'],
            dim_cd=list(
                filter(lambda x: x['Iba_Fld_Nm'] == 'dim_cd',
                       dc_field_defs))[0]['Fld_En_Nm'],
            ind_val=ind_val
        )

    script += ';\n'
    logging.debug('Script is >>>>>>\n' + script + '<<<<<<<\n')

    return script


def gen_script_for_alg_2(dc_def):
    logging.debug('Generating script for {} using algorithm 2'.format(dc_def['Data_Col_Id']))

    dc_field_defs = get_index_def(dc_def['Data_Col_Id'])

    script = '\nset hive.exec.dynamic.partition=true;' \
             '\nset hive.exec.dynamic.partition.mode=nonstrict;' \
             '\nset hive.exec.max.dynamic.partitions=100000;' \
             '\nset hive.exec.max.dynamic.partitions.pernode=100000;'

    script += '\nfrom (%s) as src_tbl\n' % dc_def['Data_Colsql'].rstrip(' ;\n\r')

    script += "insert overwrite table {dbname}.{tablename} " \
              "partition (data_col_catg='{data_col_catg}', data_col_id='{data_col_id}', ind_id)\n".format(
        dbname=idx_dbname,
        tablename=idx_tablename,
        data_col_catg=dc_def['Data_Col_Catg'],
        data_col_id=dc_def['Data_Col_Id'])

    script += "select {data_cycle}, " \
              "{region_cd}, {dim_cd}, {ind_val}, {ind_id}\n".format(
        data_cycle=list(filter(
            lambda x: x['Iba_Fld_Nm'] == 'data_cycle',
            dc_field_defs))[0]['Fld_En_Nm'],
        region_cd=list(filter(
            lambda x: x['Iba_Fld_Nm'] == 'region_cd',
            dc_field_defs))[0]['Fld_En_Nm'],
        dim_cd=list(filter(lambda x: x['Iba_Fld_Nm'] == 'dim_cd', dc_field_defs))[0]['Fld_En_Nm'],
        ind_val='value',
        ind_id=list(filter(lambda x: x['Iba_Fld_Nm'] == 'ind_id', dc_field_defs))[0]['Fld_En_Nm']
    )

    script += ';\n'
    logging.debug('Script is >>>>>>\n' + script + '<<<<<<<\n')
    return script


def gen_script_for_alg_3(dc_def):
    logging.debug('Generating script for {} using algorithm 3'.format(dc_def['Data_Col_Id']))

    dc_field_defs = get_index_def(dc_def['Data_Col_Id'])

    idx_fields = list(filter(lambda x: x['Ind_Id'] is not None and x['Ind_Id'] != '', dc_field_defs))

    script = '\nset hive.exec.dynamic.partition=true;' \
             '\nset hive.exec.dynamic.partition.mode=nonstrict;' \
             '\nset hive.exec.max.dynamic.partitions=100000;' \
             '\nset hive.exec.max.dynamic.partitions.pernode=100000;'

    script += '\nfrom (%s) as src_tbl\n' % dc_def['Data_Colsql'].rstrip(' ;\n\r')

    for idx_field in idx_fields:
        script += "insert overwrite table {dbname}.{tablename} " \
                  "partition (data_col_catg='{data_col_catg}', data_col_id='{data_col_id}', ind_id)\n".format(
            dbname=idx_dbname,
            tablename=idx_tablename,
            data_col_catg=dc_def['Data_Col_Catg'],
            data_col_id=dc_def['Data_Col_Id'])

        script += "select {data_cycle}, " \
                  "{region_cd}, {dim_cd}, {ind_val}, {ind_id}\n".format(
            data_cycle=list(filter(
                lambda x: x['Iba_Fld_Nm'] == 'data_cycle',
                dc_field_defs))[0]['Fld_En_Nm'],
            region_cd=list(filter(
                lambda x: x['Iba_Fld_Nm'] == 'region_cd',
                dc_field_defs))[0]['Fld_En_Nm'],
            dim_cd=list(
                filter(lambda x: x['Iba_Fld_Nm'] == 'dim_cd',
                       dc_field_defs))[0]['Fld_En_Nm'],
            ind_val=idx_field['Fld_En_Nm'],
            ind_id="concat({ind_id_1}, '{ind_id_2}')".format(
                ind_id_1=list(filter(lambda x: x['Iba_Fld_Nm'] == 'ind_id', dc_field_defs))[0]['Fld_En_Nm'],
                ind_id_2=idx_field['Ind_Id']
            )
        )

    script += ';\n'
    logging.debug('Script is >>>>>>\n' + script + '<<<<<<<\n')
    return script


generators = {
    'ALG001': gen_script_for_alg_1,
    'ALG002': gen_script_for_alg_2,
    'ALG003': gen_script_for_alg_3
}

if __name__ == '__main__':

    logging.basicConfig(filename='idx-tool.log', filemode='w', level=logging.DEBUG,
                        format='%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')

    logging.info('Program started.')

    config = configparser.ConfigParser()

    config.read('idx-tool.ini')

    script_dir = ''
    try:
        idx_dbname = config.get('idx-tool', 'idx_dbname')
        idx_tablename = config.get('idx-tool', 'idx_tablename')
        script_dir = config.get('idx-tool', 'script_dir', fallback='.')
    except configparser.NoOptionError:
        logging.error('Required configuration is not found.')
        print("Program failed.")
        exit(-1)

    if not os.path.exists(script_dir):
        os.mkdir(script_dir)

    conn = mysql.connector.connect(host=config.get('idx-cfg', 'dbhost'),
                                   port=3306,
                                   user=config.get('idx-cfg', 'dbuser'),
                                   passwd=config.get('idx-cfg', 'dbpasswd'),
                                   charset='utf8')

    data_col_def = get_data_collection_def()

    failed_dc = []
    for dc in data_col_def:
        script = ''
        try:
            script = generators[dc['Algor_Type']](dc)
        except IndexError:
            logging.error('Inconsistent configuration found for data collection {}'.format(dc['Data_Col_Id']))
            failed_dc.append(dc['Data_Col_Id'])
            continue

        category_dir = script_dir + os.sep + dc['Data_Col_Catg']
        if not os.path.exists(category_dir):
            os.mkdir(category_dir)

        f = io.open(category_dir + os.sep + dc['Data_Col_Id'] + '.sql', 'w', encoding='utf-8')
        f.write(script)
        f.close()

    conn.close()

    if len(failed_dc) > 0:
        print("\nFailed to generate script for following data collections, please see idx-tool.log for details.")
        for i in range(len(failed_dc)):
            print('{}: {}'.format(i+1, failed_dc[i]))
        exit(-1)

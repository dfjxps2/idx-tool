# -*- coding: utf-8 -*-
import os
import logging
import mysql.connector
import configparser
import io
from mysql_utils import MySQLUtils
from operator import itemgetter
from itertools import groupby


def get_dm_table_def():
    cursor = conn.cursor()

    sql = 'select * from idxcfg.b05_dm_tbl'

    cursor.execute(sql)

    rs = MySQLUtils.get_rs_as_dict(cursor)

    cursor.close()

    rs.sort(key=itemgetter('tgt_tbl_nm'))

    return groupby(rs, itemgetter('tgt_tbl_nm'))


def get_dm_column_def(dm_table_nm):
    cursor = conn.cursor()

    sql = "select * from idxcfg.b05_dm_col where tgt_tbl_nm = '{}' order by tgt_col_num".format(dm_table_nm)

    cursor.execute(sql)

    rs = MySQLUtils.get_rs_as_dict(cursor)

    cursor.close()

    return rs


def gen_dm_loading_script(dm_table_nm, dm_table_mapping):
    dm_column_def = get_dm_column_def(dm_table_nm)

    sql = 'FROM'
    first_table = True
    last_src_tbl_nm = ''
    for src_tbl in dm_table_mapping:
        if not first_table:
            sql += '\nINNER JOIN'

        sql += '\n(SELECT data_col_id, data_col_catg, data_cycle, region_cd, dim_cd'
        idx_list = src_tbl['ind_list'].split(',')
        for idx in idx_list:
            sql += '\n,SUM(CASE WHEN ind_id = \'{idx}\' THEN ind_val ELSE 0 END) AS {idx}'.format(idx=idx)

        sql += "\nFROM {}.{}" \
               "\nWHERE".format(idx_dbname, idx_tablename)

        sql += "\ndata_col_id = '{}'" \
               "\nAND data_col_catg = '{}'".format(src_tbl['data_col_id'], src_tbl['data_col_catg'])

        if src_tbl['data_cycle'] != '' and src_tbl['data_cycle'] is not None and src_tbl['data_cycle'][0] != '$':
            sql += "\nAND data_cycle = '{}'".format(src_tbl['data_cycle'])

        if src_tbl['region_cd'] != '' and src_tbl['region_cd'] is not None:
            sql += "\nAND region_cd = '{}'".format(src_tbl['region_cd'])

        if src_tbl['dim_cd'] != '' and src_tbl['dim_cd'] is not None:
            sql += "\nAND dim_cd = '{}'".format(src_tbl['dim_cd'])

        sql += "\nAND ind_id in ({})".format("'" + src_tbl['ind_list'].replace(',', "','") + "'")

        sql += '\nGROUP BY data_col_id, data_col_catg, data_cycle, region_cd, dim_cd) AS {}'.format(
            src_tbl['src_tbl_nm'])

        if not first_table:
            sql += "\nON {last_src_tbl}.region_cd = {this_src_tbl}.region_cd " \
                   "\nAND {last_src_tbl}.dim_cd = {this_src_tbl}.dim_cd".format(last_src_tbl=last_src_tbl_nm,
                                                                                this_src_tbl=src_tbl['src_tbl_nm'])
            if src_tbl['data_cycle'] == '${LASTYEAR}':
                sql += "\nAND CAST({last_src_tbl}.data_cycle AS INT) - CAST({this_src_tbl}.data_cycle AS INT) = 1".format(
                    last_src_tbl=last_src_tbl_nm, this_src_tbl=src_tbl['src_tbl_nm']
                )
            elif src_tbl['data_cycle'] == '${LASTMONTH}':
                sql += "\nAND (CAST(SUBSTR({last_src_tbl}.data_cycle,1,4) AS INT) * 12 + CAST(SUBSTR({last_src_tbl}.data_cycle,5,2) AS INT)) -" \
                       "(CAST(SUBSTR({this_src_tbl}.data_cycle,1,4) AS INT) * 12 + CAST(SUBSTR({this_src_tbl}.data_cycle,5,2) AS INT)) = 1".format(
                    last_src_tbl=last_src_tbl_nm, this_src_tbl=src_tbl['src_tbl_nm']
                )
        else:
            first_table = False

        last_src_tbl_nm = src_tbl['src_tbl_nm']

    sql += "\nINSERT OVERWRITE TABLE " + dm_table_nm + " PARTITION (data_dt='${data_dt}') SELECT"

    first_column = True
    for col_def in dm_column_def:
        if first_column:
            sql += "\n"
            first_column = False
        else:
            sql += "\n,"
        sql += format(col_def['tgt_col_expr'] + ' -- ' + col_def['tgt_col_nm_cn'])

    sql += "\n;"

    return sql


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

    dm_table_def = get_dm_table_def()

    for tgt_table, group in dm_table_def:
        tbl_mapping_list = list(group)
        script = gen_dm_loading_script(tgt_table, tbl_mapping_list)
        f = io.open(script_dir + os.sep + tgt_table + '.sql', 'w', encoding='utf-8')
        f.write(script)
        f.close()

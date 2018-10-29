# 北京副中心项目指标数据加载脚本生成工具
## 安装与配置
- 从https://github.com/dfjxps2/idx-tool下载idx-tool工具包
- 将下载的工具包解压，假设解压路径为<idx-tool>。
- 在一个可以访问的MySQL数据库服务器上创建名为idxcfg的数据库，默认字符集使用UTF8。
- 执行<idx-tool>/idxcfg.sql在idxcfg数据库中创建idx-tool所需的配置表，并导入样本配置数据。
- 编辑<idx-tool>/idx-tool.ini文件，设置所需的参数，参数说明如下：
``` ini
[idx-tool]
idx_dbname=indexdb              # 指标数据表所在数据库（hive）的名称
idx_tablename=b04_base_data_tbl # 指标数据表表名
script_dir=output               # 生成脚本的存放目录
[idx-cfg]
dbhost=localhost                # 配置数据库服务器名称或IP
dbuser=root                     # 配置数据库服务器用户名
dbpasswd=root                   # 配置数据库用户口令
```
## 生成脚本
- Linux环境<br>
在<idx-tool>目录下，执行：
``` shell
source venv-linux/bin/activate
python idx-script-gen.py
```
可以在参数script_dir所指向的目录下看到生成的脚本文件。
- Windows环境<br>
打开命令行窗口，在<idx-tool>目录下，执行：
``` bat
venv\scripts\activate.bat
python idx-script-gen.py
```
可以在参数script_dir所指向的目录下看到生成的脚本文件。

## 注意事项
- 请确保配置数据集配置表中定义的源数据计算SQL书写正确，该SQL的执行结果中各字段的名称必须与指标配置表中定义的字段名完全一致。
- 


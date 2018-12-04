# 北京市大数据平台及领导驾驶舱项目指标数据加载脚本生成工具
## 安装与配置
- 下载[idx-tool工具包](https://github.com/dfjxps2/idx-tool/archive/master.zip)。
- 将下载的工具包解压，假设解压路径为\<idx-tool\>。
- 在一个MySQL数据库服务器上（版本5.6+）创建名为idxcfg的数据库，默认字符集选择UTF8。
- 执行\<idx-tool\>/idxcfg.sql在idxcfg数据库中创建idx-tool所需的配置表，并导入样本配置数据。
- 编辑\<idx-tool\>/idx-tool.ini文件，设置所需的参数，参数说明如下：
``` ini
[idx-tool]
idx_dbname=indexdb              # 指标数据表所在数据库（hive）的名称
idx_tablename=b04_base_data_tbl # 指标数据表表名
script_dir=output               # 存放生成的脚本的目录
[idx-cfg]
dbhost=localhost                # 存放配置信息的数据库服务器名称或IP
dbuser=root                     # 存放配置信息的数据库服务器用户名
dbpasswd=root                   # 存放配置信息的数据库用户口令
```
## 生成脚本
- Linux（Ubuntu）环境<br>
在\<idx-tool\>目录下，执行：
``` shell
source venv-linux/bin/activate
python idx-script-gen.py
```
可以在参数script_dir所指向的目录下看到生成的脚本文件。
- Windows 10 x64 环境<br>
1. 安装Python 3.7.1 amd64版本。
2. 打开命令行窗口，在\<idx-tool\>目录下，执行：
``` bat
venv\scripts\python idx-script-gen.py
```
可以在参数script_dir所指向的目录下看到生成的脚本文件。

## 注意事项
- 请确保配置数据集配置表中定义的源数据计算SQL书写正确，该SQL的执行结果中各字段的名称必须与指标配置表中定义的字段名完全一致。
- 请参考idxcfg.sql中的配置数据样本配置其他的指标和数据集。


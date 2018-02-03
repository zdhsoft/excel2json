# excel2json 一个excel转json的工具
- 这个工具是基于python 2.7.x的，对于excel的部分，使用的是xlrd这个开源库，在使用之前，请确定安装了这个库。
- xlrd http://pypi.python.org/pypi/xlrd
- 1. bat必须与指定的excel同名，如:test.xls，脚本工具命名为：test.bat
- 2. excel中必须有一个tab页命名为：tablelist，填写转换配置、生成的目标文件名字和映射关系表
- 3. 映射表可以不写，表示直接根绝filename中的表头生成
- 4. 映射表可以只列出filename中的一部分表头，生成时就只生成指定的列的信息
- 5. 如果是字符串，无需对内容加双引号，直接对表头使用双引号即可


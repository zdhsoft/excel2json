# 注意：这个版本不再更新维护，现在改到使用typescript的版本了
下面是这个github的连接 https://github.com/zdhsoft/excel2json_by_ts

# excel2json 一个excel转json的工具
- 这个工具是基于python 2.7.x的，对于excel的部分，使用的是xlrd这个开源库，在使用之前，请确定安装了这个库。
- xlrd http://pypi.python.org/pypi/xlrd
- 1. bat必须与指定的excel同名，如:test.xls，脚本工具命名为：test.bat
- 2. excel中必须有一个tab页命名为：tablelist，填写转换配置、生成的目标文件名字和映射关系表
- 3. 映射表可以不写，表示直接根绝filename中的表头生成
- 4. 映射表可以只列出filename中的一部分表头，生成时就只生成指定的列的信息
- 5. 如果是字符串，无需对内容加双引号，直接对表头使用双引号即可

## 更新记录
### 2019-11-06
- 准备放弃 python 2.x的支持了，主要是python 3.x为主要目标了 现在centos 8也支持 python3.x了

### 2019-05-27
- fixbug：生成json有特殊字符的问题
- fixbug: 生成json字符串数组的问题

## 增加了一个3.6.x的版本
- 文件名：excel2conf.3.py 使用的python 3.6.4的　tools/script/2to3.py这个脚本转的
- 用pip命令安装xlrd  
```dos
pip install xlrd
```
- 然后就可以运行了

## 增加了一个key-object模式json输出
如下格式：
```json
//filename: test.json
{
	"test001": { "cn":"dd", "en":"dd", "yn":"dff" },
	"test002": { "cn":"dd2", "en":"dd", "yn":"fff" }
}


//node.js下调用：
let r = require('./test.json')
console.log(r)
//打印的结果，就和这个表的结果是一样的

```

### key-object配置
在excel表格的tablelist,增加了一列是type,如果没有定义，则按照原来的array方式输出。
如果有定义，则按要求输出：格式是  key:map
- key表示是要做为key的字段名,如id,account等等
- map表示是类型，固定值为map
具体配置：参考language.xlsx表中的定义。

## 增加对字段别名的支持
在excel表中的tablelist表中fields列中，增加了别名的支持（支持原来是中文的名称）
如language.xlsx中
```
filename	describe	outfilename	fields
language	测试	language_cn.json	id,中文:txt
language	测试	language_en.json	id,en:txt
language	测试	language_yn.json	id,yn:txt
```
生成json后，输出的字段名都变成txt了。


## 数据类型说明
- 在具体数据表的字段名称上面有""括起来的，表示这例数据是字符串
- 没有引号的则主要是数字或数组，对于数字，如果没有小数的，则会生成整数
```python
def FloatToString (aFloat):
    if type(aFloat) != float:
        return ""
    strTemp = str(aFloat)
    strList = strTemp.split(".")
    if len(strList) == 1 :
        return strTemp
    else:
        if strList[1] == "0" :
            return strList[0]
        else:
            return strTemp
```

## 输出支持的格式
- csv 通用的csv表格格式
```csv
Field1,Field2,Field3,Field4
test1,1,["hello","hello1"],[1,2]
test2,2,["ssss","abc"],[3,4]
```
- jsn json数据格式
```json
{
	"list":[
		{ "Field1":"test1", "Field2":1, "Field3":["hello","hello1"], "Field4":[1,2] },
		{ "Field1":"test2", "Field2":2, "Field3":["ssss","abc"], "Field4":[3,4] }
	]
}

```
- conf ini的格式
```ini
[mytest1]
Field1 = test1
Field2 = 1
Field3 = ["hello","hello1"]
Field4 = [1,2]

[mytest2]
Field1 = test2
Field2 = 2
Field3 = ["ssss","abc"]
Field4 = [3,4]

[mytest]
Count = 2
```

## 去除的类型
因为sql和key以及as3已经基本上用不了，在这里删除了对这三种数据的支持

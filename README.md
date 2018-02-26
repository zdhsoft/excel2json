# excel2json 一个excel转json的工具
- 这个工具是基于python 2.7.x的，对于excel的部分，使用的是xlrd这个开源库，在使用之前，请确定安装了这个库。
- xlrd http://pypi.python.org/pypi/xlrd
- 1. bat必须与指定的excel同名，如:test.xls，脚本工具命名为：test.bat
- 2. excel中必须有一个tab页命名为：tablelist，填写转换配置、生成的目标文件名字和映射关系表
- 3. 映射表可以不写，表示直接根绝filename中的表头生成
- 4. 映射表可以只列出filename中的一部分表头，生成时就只生成指定的列的信息
- 5. 如果是字符串，无需对内容加双引号，直接对表头使用双引号即可

## 增加了一个3.6.x的版本
- 文件名：excel2conf.3.py 使用的python 3.6.4的　tools/script/2to3.py这个脚本转的
- 用pip命令安装xlrd  
```dos
pip install xlrd
```
- 然后就可以运行了

## 增加对字段别名的支持
在excel表中的tablelist表中fields列中，增加了别名的支持
如language.xlsx中
```
filename	describe	outfilename	fields
language	测试	language_cn.json	id,cn:txt
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
- sql 生成插入数据的sql语句
```sql
truncate table mytest;
set names 'utf8';
set autocommit=0;
insert into mytest set Field1 = 'test1', Field2 = 1, Field3 = ["hello","hello1"], Field4 = [1,2];
insert into mytest set Field1 = 'test2', Field2 = 2, Field3 = ["ssss","abc"], Field4 = [3,4];
commit;
```
- key 放弃不使用了
- cfg 生成as3读取代码和配置数据(这种方式是一种自定方式数据格式） 也是基本上放弃不使用了  在as3souce目录下面，有所有相关解析的代码。
```data
[CMyTest]
<Field4,Field3,Field2,Field1>
#[1,2],["hello","hello1"],1,"test1"
#[3,4],["ssss","abc"],2,"test2"
```
```actionscript
package com.hxgd.cfg
{
    public class CMyTest extends ConfigBase
    {
        public function CMyTest()
        {
            super();
        }

        override public function DoLoad(paramRecord:Array):void
        {
            Field4 = paramRecord[0];
            Field3 = paramRecord[1];
            Field2 = paramRecord[2];
            Field1 = paramRecord[3];
        }

        public var Field4:Array=[];
        public var Field3:Array=[];
        public var Field2:Number;
        public var Field1:String;
    }
}

```


#!/usr/bin/python
# -*- coding: utf-8 -*-
# 这段代码主要的功能是把excel表格转换成utf-8格式的json文件
# lastdate:2011-8-15 14:21 version 1.1 

import os
import sys
import codecs
import xlrd #http://pypi.python.org/pypi/xlrd

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

def ParseExtType(paramExtType):
    strList = paramExtType.split(":")
    retType = {}
    if len(strList) == 2:
        retType["key"] = strList[0]
        retType["type"] = strList[1]
    else:
        retType["key"] = ""
        retType["type"] = ""
    return retType


#查找第1个非要求的字符串的下标
def findFirstNot(str, begin, substr):
    for i in range(begin, len(str)):
        if substr.find(str[i]) == -1:
            return i
    return -1

#解析filter字符串，返回变量数组
def parseFilterKey(filter):
    ret = []
    begin = 0
    while True:
        index = filter.find("$", begin)
        if index >= 0:
            index += 1
            end = findFirstNot(filter, index, "1234567890abcdefghijklmnopqrstuvwxyz_ABC DEFGHIJKLMNOPQRSTUVWXYZ")
            key = filter[index:end]
            ret.append(key)
            begin = end
        else:
            return ret

#读入字段映射表
def readMap(table):
    mapTable = {}
    nrow = table.nrows
    if table.ncols == 0:
        return mapTable

    for r in range(nrow):
        k = table.cell_value(r, 0)
        if table.ncols < 2:
            v = k
        else:
            v = table.cell_value(r, 1)
            if (len(v) == 0):
                v = k
        mapTable[k] = v
    return mapTable

#读取字段列表
def readFieldMap(paramFields):
    mapField = {}
    strList = paramFields.split(",")
    for f in strList:
        strNameList = f.split(":");
        if len(strNameList) > 1:
            mapField[strNameList[0]]=strNameList[1];
        else:
            mapField[f] = f

    return mapField

#            table2as3config(destTable, destFileName, mapTable, mapParam)

def CellToString(paramCell):
    strCellValue = ""
    if type(paramCell) == str:
        strCellValue = paramCell
    elif type(paramCell) == float:
        strCellValue = FloatToString(paramCell)
    else:
        strCellValue = str(paramCell)
    return strCellValue

def IsEmptyLine(paramTable, paramRow, paramFieldCount):
    linecnt = 0
    for i in range(paramFieldCount-1):
        v = paramTable.cell_value(paramRow, i)
        if type(v) == str:
            v = v
        elif type(v) == float:
            v = FloatToString(v)
        else:
            v = str(v)
        linecnt += len(v)
        if linecnt > 0:
            return False

    if linecnt == 0:
        return True
    else:
        return False

def table2map(table, jsonfilename, mapTable, key):
    nrows = table.nrows
    ncols = table.ncols
    hasMap = (len(mapTable) > 0)
    dir = os.path.dirname(jsonfilename)
    if dir and not os.path.exists(dir):
        os.makedirs(dir)    
    f = codecs.open(jsonfilename,"w","utf-8")
    strTmp = ""
    strTmp += "{\n"
    f.write(strTmp)
    
    keyIndex = -1

    for c in range(ncols):
        t = table.cell_value(0, c)
        t = t.replace("\n", "").replace("\"", "")
        if key == t:
            keyIndex = c
            break

    rs = 0
    for r in range(1, nrows):
        if IsEmptyLine(table, r, ncols):  #跳过空行
            continue
        i = 0

        keyValue = table.cell_value(r,keyIndex)
        if type(keyValue) == str:
            keyValue = keyValue
        elif type(keyValue) == float:
            keyValue = FloatToString(keyValue)
        else:
            keyValue = str(keyValue)

        strTmp = "\t\""+keyValue + "\": { ";

        for c in range(ncols):
            title = table.cell_value(0,c)
            isString = (title.rfind("\"") >= 0)
            title = title.replace("\n", "").replace("\"", "")

            if hasMap:
                if not title in mapTable:
                    continue
                else:
                    title = mapTable[title]

            strCellValue = ""
            CellObj = table.cell_value(r,c)
            if type(CellObj) == str:
                strCellValue = CellObj.replace("\\", "\\\\").replace("\"", "\\\"")
            elif type(CellObj) == float:
                strCellValue = FloatToString(CellObj)
            else:
                strCellValue = str(CellObj)

            if isString:
                strCellValue = strCellValue.replace("\n", "");

            if i > 0:
                delm = ", "
            else:
                delm = ""

            if isString:
                strTmp += delm + "\""  + title + "\":\""+ strCellValue + "\""
            else:
                strTmp += delm + "\""  + title + "\":"+ strCellValue
            i += 1
        
        strTmp += " }"
        if rs > 0:  #不是第1行
            f.write(",\n")
        f.write(strTmp)
        rs += 1

    strTmp = ""
    if "name" in mapParam:
        if (len(mapParam["name"]) > 0):
            strTmp += "\n}"
    else:
        strTmp += "\n}"

    strTmp += "\n"
    f.write(strTmp)
    f.close()
    print("Create ",jsonfilename," OK")
    return

def table2jsn(table, jsonfilename, mapTable):
    nrows = table.nrows
    ncols = table.ncols
    hasMap = (len(mapTable) > 0)
    dir = os.path.dirname(jsonfilename)
    if dir and not os.path.exists(dir):
        os.makedirs(dir)    
    f = codecs.open(jsonfilename,"w","utf-8")
    strTmp = ""
    strTmp += "{\n\t\"list\":"
    if len(strTmp) == 0:   #此时加个\t使前后对齐
        strTmp += "\t[\n"
    else:
        strTmp += "[\n"

    rs = 0
    f.write(strTmp)
    for r in range(1, nrows):
        if IsEmptyLine(table, r, ncols):  #跳过空行
            continue
        strTmp = "\t\t{ "
        i = 0

        for c in range(ncols):
            title = table.cell_value(0,c)
            isString = (title.rfind("\"") >= 0)
            title = title.replace("\n", "").replace("\"", "")

            if hasMap:
                if not title in mapTable:
                    continue
                else:
                    title = mapTable[title]

            strCellValue = ""
            CellObj = table.cell_value(r,c)
            if type(CellObj) == str:
                strCellValue = CellObj.replace("\\", "\\\\").replace("\"", "\\\"")
            elif type(CellObj) == float:
                strCellValue = FloatToString(CellObj)
            else:
                strCellValue = str(CellObj)

            if isString:
                strCellValue = strCellValue.replace("\n", "")

            if i > 0:
                delm = ", "
            else:
                delm = ""

            if isString:
                strTmp += delm + "\""  + title + "\":\""+ strCellValue + "\""
            else:
                strTmp += delm + "\""  + title + "\":"+ strCellValue
            i += 1
        
        
        strTmp += " }"
        if rs > 0:  #不是第1行
            f.write(",\n")
        f.write(strTmp)
        rs += 1

    strTmp = "\n\t]"
    if "name" in mapParam:
        if (len(mapParam["name"]) > 0):
            strTmp += "\n}"
    else:
        strTmp += "\n}"

    strTmp += "\n"
    f.write(strTmp)
    f.close()
    print("Create ",jsonfilename," OK")
    return

def table2ini(table, inifilename, mapTable):

    nrows = table.nrows
    ncols = table.ncols
    hasMap = (len(mapTable) > 0)
    dir = os.path.dirname(inifilename)
    if dir and not os.path.exists(dir):
        os.makedirs(dir)

    section = destFileName[:destFileName.rfind(".")]    #用文件名做节名
    section = section[section.rfind("\\")+1:]

    f = codecs.open(inifilename,"w","utf-8")
    rs = 1
    for r in range(1, nrows):
        if IsEmptyLine(table, r, ncols):  #跳过空行
            continue
        strTmp = "[" + section + str(rs) + "]\n"
        
        for c in range(ncols):
            title = table.cell_value(0,c)
            isString = (title.rfind("\"") >= 0)
            title = title.replace("\n", "").replace("\"", "")

            if hasMap:
                if not title in mapTable:
                    continue
                else:
                    title = mapTable[title]

            strCellValue = ""
            CellObj = table.cell_value(r,c)
            if type(CellObj) == str:
                strCellValue = CellObj
            elif type(CellObj) == float:
                strCellValue = FloatToString(CellObj)
            else:
                strCellValue = str(CellObj)

            strCellValue = strCellValue.replace("\n", "")  #去掉换行
            strTmp += title + " = "+ strCellValue + "\n"

        rs += 1
        strTmp += "\n"
        f.write(strTmp)

    strTmp = "[" + section + "]\n"
    strTmp += "Count = " + str(rs - 1) + "\n"
    f.write(strTmp)

    f.close()
    print("Create ",inifilename," OK")
    return

def table2csv(table, csvfilename, mapTable):
    nrows = table.nrows
    ncols = table.ncols
    hasMap = (len(mapTable) > 0)
    dir = os.path.dirname(csvfilename)
    if dir and not os.path.exists(dir):
        os.makedirs(dir)
    f = codecs.open(csvfilename,"w","utf-8-sig")  #为了excel能够正确打开，这里输出的csv文件是UTF-8 BOM格式的
    for r in range(nrows):
        if IsEmptyLine(table, r, ncols):  #跳过空行
            continue
        i = 0
        strTmp = ""
        for c in range(ncols):
            title = table.cell_value(0,c)
            isString = (title.rfind("\"") >= 0)
            title = title.replace("\n", "").replace("\"", "").replace(",", "")

            if hasMap:
                if not title in mapTable:
                    continue
                else:
                    title = mapTable[title]

            if i > 0:
                delm = ","
            else:
                delm = ""

            if r == 0:  #第一行不同
                strTmp += delm + title
            else:
                strCellValue = ""
                CellObj = table.cell_value(r,c)
                if type(CellObj) == str:
                    strCellValue = CellObj.replace("\n", "")#.replace(u",", u"")
                elif type(CellObj) == float:
                    strCellValue = FloatToString(CellObj)
                else:
                    strCellValue = str(CellObj).replace("\n", "").replace(",", "")

                if isString:
                    strTmp += delm + "\""+ strCellValue + "\""
                else:
                    strTmp += delm + strCellValue

            i += 1
        strTmp += "\n"
        f.write(strTmp)
    f.close()
    print("Create ",csvfilename," OK")
    return

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: %s <excel_file>' % sys.argv[0])
        sys.exit(1)

    print("handle file: %s" % sys.argv[1])

    excelFileName = sys.argv[1]
    data = xlrd.open_workbook(excelFileName)
    table = data.sheet_by_name("tablelist")
    rs = table.nrows
    for r in range(rs-1):
        destTableName = table.cell_value(r+1,0)
        destFileName = table.cell_value(r+1,2)
        s = "undefined"

        strUseFields = ""
        if (table.ncols >= 4):
            strUseFields = table.cell_value(r+1,3)
        strClassName = ""
        if (table.ncols >= 5):
            strClassName = table.cell_value(r+1,4)
        stFieldList = strUseFields.split(",")  #有用的字段列表

        strExtType = ""
        if(table.ncols >= 6):
            strExtType = table.cell_value(r+1, 5)

        retType = ParseExtType(strExtType)
        print(strExtType, retType, retType["key"], retType["type"])

        mapParam = {}

        print("\nCreate " + destTableName + " ==> " + destFileName + " Starting...")

        destTable = data.sheet_by_name(destTableName)
        mapTable = readFieldMap(strUseFields)

        suffix = destFileName[destFileName.rfind("."):].lower()
        if suffix == ".csv":
            table2csv(destTable, destFileName, mapTable)
        elif suffix == ".jsn" or suffix == ".js" or suffix == ".json":
            if retType["type"] == "map":
                table2map(destTable, destFileName, mapTable, retType["key"])
            else:
                table2jsn(destTable, destFileName, mapTable)
        elif suffix == ".conf":
            table2ini(destTable, destFileName, mapTable)
        else:
            print("当前类型是:", suffix)
            print("only support (jsn,js,json), conf format")
            exit(1)

    print("All OK")

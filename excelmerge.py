#!/usr/bin/python
# -*- coding: utf-8 -*-

# 需要安装xlrd和xlsxwrite这两个库
# pip install xlrd
# pip install xlsxwriter

import xlrd
import xlsxwriter as xx
import os

# 要合并的列表

xlslist = [
			"./flow_avenger_yb.xlsx",
			"./flow_avenger_rex.xlsx",
			"./flow_avenger_mdz.xlsx",
			"./flow_avenger_llz.xlsx",
			"./flow_llz.xlsx",
			"./flow_rex.xlsx",
			"./flow_mdz.xlsx"
           ]
# 目标文件

destfile = "./flow.xlsx"

# 要合并的表

sheetlist = ["link", "model", "node", "sub_node", "flow", "procedures", "checker"]
firstsheetlist = ["tablelist"]


def excel_firstsheet(param_sheet_list, param_src_list, param_dest_file):
    print 'excel excel_firstsheet'
    for sheet_name in param_sheet_list:
        sheet = param_src_list.sheet_by_name(sheet_name)
        newsheet = param_dest_file.add_worksheet(sheet_name)
        nrows = sheet.nrows
        ncols = sheet.ncols
        print '    first:' + sheet_name

        for r in range(nrows):
            for c in range(ncols):
                cell = sheet.cell_value(r, c)
                newsheet.write(r, c, cell)


# 合并excel
def excel_merge(param_sheet_name, param_file_list, param_dest_file):
    newsheetrow = 0
    print '    excelMarge:', param_sheet_name
    newsheet = param_dest_file.add_worksheet(param_sheet_name)
    for f in param_file_list:
        sheet = f.sheet_by_name(param_sheet_name)
        nrows = sheet.nrows
        ncols = sheet.ncols

        for r in range(nrows):
            if r == 0 and newsheetrow > 0:
                # 第一行不复制
                continue

            for c in range(ncols):
                cell = sheet.cell_value(r, c)
                newsheet.write(newsheetrow, c, cell)

            newsheetrow = newsheetrow + 1

        newsheetrow = newsheetrow + 1


def main():
    if os.path.exists(destfile):
        print 'file:' + destfile + ' is exists will be delete'
        os.remove(destfile)
        print 'delete file ok!'
    else:
        print 'file:' + destfile + 'is not exists!'

    newfile = xx.Workbook(destfile)
    openlist = []

    for excel_file in xlslist:
        if os.path.exists(excel_file):
            efile = xlrd.open_workbook(excel_file)
            openlist.append(efile)
        else:
            print 'not found file:' + excel_file

    if len(openlist) > 0:
        excel_firstsheet(firstsheetlist, openlist[0], newfile)

    print 'excel marge:'
    for sheet_name in sheetlist:
        excel_merge(sheet_name, openlist, newfile)

    newfile.close()


if __name__ == "__main__":
    main()

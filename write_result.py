import openpyxl
import scipy.io

mode = 2
question = 3
# 加载.mat文件
data = scipy.io.loadmat(f'Q{question}_popu_mode{mode}.mat')['popu'][0, 0]
if question == 1:
    file_path = f'附件3/result1_{mode}.xlsx'
else:
    file_path = f'附件3/result{question}.xlsx'

wb = openpyxl.load_workbook(file_path)

for year in range(2024, 2031):
    y_data = data[0, year - 2024]

    # 选择要操作的工作表
    ws = wb[str(year)]  # 或者使用 ws = wb['SheetName'] 来选择特定的工作表

    # 从B2开始插入矩阵
    start_row = 2  # 从第2行开始
    start_col = 3  # 从B列开始，对应的是第3列

    # 将矩阵数据写入到指定的位置
    for i in range(y_data.shape[0]):  # 遍历矩阵的行
        for j in range(y_data.shape[1]):  # 遍历矩阵的列
            ws.cell(row=start_row + i, column=start_col + j, value=y_data[i, j])

# 保存修改后的Excel文件
wb.save(file_path)

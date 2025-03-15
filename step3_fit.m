clc;
clear;
close all
data=xlsread('相关性分析表.xlsx');

unit_price = data(:,1);
selling_price = data(:,2);
sales_volume = data(:,3);
[rho, pval] = corr(data, 'Type', 'Spearman');


figure;
imagesc(rho);
colorbar;
n = 64;
cmap = zeros(n, 3);
cmap(:, 1) = 1;
cmap(:, 2) = linspace(0, 1, n);
cmap(:, 3) = 0;
colormap(cmap);
title('Spearman Correlation Coefficient Heatmap');
axis square;

% 设置轴标签
set(gca, 'XTick', 1:3, 'XTickLabel', {'售价', '成本', '销量'});
set(gca, 'YTick', 1:3, 'YTickLabel', {'售价', '成本', '销量'});

% 在格子上添加数值
[numRows, numCols] = size(rho);
for row = 1:numRows
    for col = 1:numCols
        if row==col
            f_color='black';
        else
            f_color='white';
        end
        text(col, row, sprintf('%.2f', rho(row, col)), ...
             'HorizontalAlignment', 'center', ...
             'Color', f_color);
    end
end

% 将输入特征组合成矩阵 X
X = [unit_price, selling_price];

net = feedforwardnet(20); 
net = train(net, X', sales_volume'); 
save('model.mat','net')
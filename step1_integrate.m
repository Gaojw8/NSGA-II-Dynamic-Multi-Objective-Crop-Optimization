clc
clear
close all;
data = xlsread('附件2.xlsx','2023年统计的相关数据');
data = data(:,[2 5 9 7 6]);
price = []; 

for i=1:41 %遍历41种蔬菜
    for ii=1:size(data,1)
        if data(ii,1)==i %找到了蔬菜
            if data(ii,2) == 0 %如果是单季种植
                price(2,i) = 0;
                price(1,i) = data(ii,3);
                break
            else %如果不是单季种植
                price(data(ii,2),i) = data(ii,3);
            end
        end
    end
end

cost = []; 

for i=1:41 %遍历41种蔬菜
    for ii=1:size(data,1)
        if data(ii,1)==i %找到了蔬菜
            if data(ii,2) == 0 %如果是单季种植
                cost(2,i) = 0;
                cost(1,i) = data(ii,4);
                break
            else %如果不是单季种植
                cost(data(ii,2),i) = data(ii,4);
            end
        end
    end
end

O = zeros(2,41); %存亩产

for i=1:41 %遍历41种蔬菜
    for ii=1:size(data,1)
        if data(ii,1)==i %找到了蔬菜
            if data(ii,2) == 0 %如果是单季种植
                O(1,i) = data(ii,5);
                break
            else %如果不是单季种植
                O(data(ii,2),i) = O(data(ii,2),i)+data(ii,5);
            end
        end
    end
end

data = xlsread('附件2.xlsx','2023年的农作物种植情况');
data = data(:,[1 5 4 6]); %作物 季次 面积 土地类型

data2 = xlsread('附件2.xlsx','2023年统计的相关数据');
data2 = data2(:,[2 4 5 6]); %作物 土地类型 季次 亩产

data_set = data; %作物 季次 面积 土地类型 亩产
for i=1:size(data,1)
    p = data(i,1); %记录植物
    L = data(i,4); %记录土地
    s = data(i,2); %记录季次
    for ii=1:size(data2,1)
        if data2(ii,1)==p && data2(ii,2) == L && data2(ii,3) == s
            data_set(i,5) = data2(ii,4);
        end
    end
end

V = zeros(2,41); %存销量

for i=1:41 %遍历41种蔬菜
    for ii=1:size(data_set,1)
        if data_set(ii,1)==i %找到了蔬菜
            if data_set(ii,2) == 0 %如果是单季种植
                V(1,i) = data_set(ii,3)*data_set(ii,5);
                break
            else %如果不是单季种植
                V(data_set(ii,2),i) = V(data_set(ii,2),i)+data_set(ii,3)*data_set(ii,5);
            end
        end
    end
end

V = 0.95*V;

save_matrix=[price(1,:);V(1,:);cost(1,:);O(1,:);price(2,:);V(2,:);cost(2,:);O(2,:)];
row=[1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40  41];
col={'第一季售价','第一季销量','第一季成本','第一季亩产','第二季售价','第二季销量','第二季成本','第二季亩产'}';
xlswrite("售价销量成本亩产表.xlsx",row,'Sheet1','B1')
xlswrite("售价销量成本亩产表.xlsx",col,'Sheet1','A2')
xlswrite("售价销量成本亩产表.xlsx",save_matrix,'Sheet1','B2')
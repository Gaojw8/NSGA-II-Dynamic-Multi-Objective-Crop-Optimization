clear
close all


question='Q2';
cond=2;

if question=='Q1'
    leg=['mean obj'];
else
    leg={'mean obj','min obj'};
end
popu_file=[question,'_popu_mode',num2str(cond),'.mat'];
obj_rec_file=[question,'_obj_record_mode',num2str(cond),'.mat'];
data = xlsread('售价销量成本亩产表.xlsx');
load(popu_file);
load(obj_rec_file);
figure
plot(obj_record,LineWidth=2)
xlabel('iter')
ylabel('收益')
title("收益迭代过程图")
legend(leg)
%统计产量

set = popu{1,1};
lables = {'黄豆','黑豆','红豆','绿豆','爬豆','小麦','玉米','谷子','高粱','黍子','荞麦','南瓜','红薯','莜麦','大麦','水稻','豇豆','刀豆','芸豆','土豆','西红柿','茄子','菠菜 ','青椒','菜花','包菜','油麦菜','小青菜','黄瓜','生菜 ','辣椒','空心菜','黄心菜','芹菜','大白菜','白萝卜','红萝卜','榆黄菇','香菇','白灵菇','羊肚菌'};
YEAR = [2024,2025,2026,2027,2027,2029,2030];
figure; % 创建一个新图形窗口  
for year = 1:7 % 遍历每年  
    V = zeros(1, 41); 
    for p = 1:41  
        for L = 1:81  
            V(p) = V(p) + set{1, year}(L, p) * data(5, p); 
        end  
    end  
      
    nonZeroIdx = V > 0;  
      
    sorted_V_nonzero = sort(V(nonZeroIdx), 'descend');  
    sorted_V_indices = find(nonZeroIdx); 
    subplot(3, 3, year);  

    bar(sorted_V_nonzero);

 
    title(sprintf('%d年', YEAR(year)));  

    xticks(1:length(sorted_V_nonzero));  
    sorted_lables_nonzero = lables(nonZeroIdx);  

    sorted_lables_nonzero = sorted_lables_nonzero(1:length(sorted_V_nonzero));  
    xticklabels(sorted_lables_nonzero);  
    
    xtickangle(45);  
end  
tit1=['情况',num2str(cond),'-作物x-产量y'];
sgtitle(tit1);
%统计种植面积
lables = {'A1','A2','A3','A4','A5','A6','B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','B12','B13','B14','C1','C2','C3','C4','C5','C6','D1','D2','D3','D4','D5','D6','D7','D8','E1','E2','E3','E4','E5','E6','E7'};
YEAR = [2024,2025,2026,2027,2027,2029,2030];
figure; % 创建一个新图形窗口  
for year = 1:7 % 遍历每年 
    temp_V = sum(set{1, year},2);
    V =   temp_V(1:54,1);
    V = V(27:54,1)+temp_V(55:end,1);
 
    nonZeroIdx = V > 0;  

    sorted_V_nonzero = sort(V(nonZeroIdx), 'descend');  
    sorted_V_indices = find(nonZeroIdx); 
    subplot(3, 3, year);  
    bar(sorted_V_nonzero); 

    title(sprintf('%d年', YEAR(year)));  
     
    xticks(1:length(sorted_V_nonzero));  

    sorted_lables_nonzero = lables(nonZeroIdx);  

    sorted_lables_nonzero = sorted_lables_nonzero(1:length(sorted_V_nonzero));  
    xticklabels(sorted_lables_nonzero);  

    xtickangle(45);  
end  
tit2=['情况',num2str(cond),'-耕地x-种植面积y'];
sgtitle(tit2);
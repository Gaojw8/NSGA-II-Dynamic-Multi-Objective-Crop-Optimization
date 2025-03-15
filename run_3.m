clc
clear
close all;
% data = xlsread('售价销量成本亩产表.xlsx');
load("E_Q3.mat");
Area = xlsread('附件1.xlsx');
% 定义参数
ITER=500;
PC=0.85;
PM=0.15;
NIND=30;
cond = 2;
% 初始化
[popu]=initialization(NIND,Area);
[obj]=NSGA_fitness(popu,E,cond);
obj_record=mean(obj);
bar = waitbar(0,'准备计算中...'); 
tic; 
% 进入循环
for iter=1:ITER
    [croed_popu]=crossover(popu,PC,Area);
    [mued_popu]=mutation(croed_popu,PM,Area);
    [obj]=NSGA_fitness(mued_popu,E,cond);
    [popu,obj]=NSGA_selection(mued_popu,obj',NIND);
    obj_record=[obj_record;mean(obj)];
    str=['计算中...',num2str(100*iter/ITER),'%'];
    waitbar(iter/ITER,bar,str)  
end
close(bar);
toc;
popu_file=['Q3_popu_mode',num2str(cond),'.mat'];
obj_file=['Q3_obj_record_mode',num2str(cond),'.mat'];
save(popu_file,"popu")
save(obj_file,"obj_record")
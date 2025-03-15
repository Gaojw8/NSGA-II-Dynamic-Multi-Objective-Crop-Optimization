data = xlsread('售价销量成本亩产表.xlsx');
Area = xlsread('附件1.xlsx');
% 定义参数
ITER=1500;
PC=0.85;
PM=0.15;
NIND=30;
cond = 1;
% 初始化
[popu]=initialization(NIND,Area);
[obj]=nor_fitness(popu,data,cond);
obj_record=max(obj);
bar = waitbar(0,'准备计算中...'); 
% 进入循环
tic; 
for iter=1:ITER
    [croed_popu]=crossover(popu,PC,Area);
    [mued_popu]=mutation(croed_popu,PM,Area);
    [obj]=nor_fitness(mued_popu,data,cond);
    [popu,obj]=nor_selection(mued_popu,obj,NIND);
    obj_record=[obj_record;max(obj)];
    str=['计算中...',num2str(100*iter/ITER),'%'];
    waitbar(iter/ITER,bar,str)  
end
close(bar);
toc;
popu_file=['Q1_popu_mode',num2str(cond),'.mat'];
obj_file=['Q1_obj_record_mode',num2str(cond),'.mat'];
save(popu_file,"popu")
save(obj_file,"obj_record")





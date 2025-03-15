function [OBJ]=NSGA_fitness(popu,E,cond)
OBJ=[];
for nind = 1:size(popu,2)
    data_set = popu{1,nind};
    obj = [];
    for e=1:size(E,2) %依次实施实验方案
        data = E{1,e};
        % 计算收入
        income = 0;
        cost = 0;
        for year = 1:size(data_set,2)            %遍历年份
            for s=1:2                       %遍历季度
                for p=1:41                  %遍历作物
                   
                    if s==1 %第一季度，只统计两季的
                        price = data{1,year}(2,p); % 售价
                        sales=data{1,year}(3,p);
                        V = 0;                      %产量
                        if p>=17 && p<=34
                            for L=1:82              %遍历每块地
                                cost = cost + data_set{1,year}(L,p)*data{1,year}(4,p);
                                V = V + data_set{1,year}(L,p)*data{1,year}(5,p);
                            end
                        else
                            continue
                        end

                    else
                        price = data{1,year}(6,p);
                        sales=data{1,year}(7,p);
                        V = 0; 
                        if p<17||p>34 %都是第二季收获的
                            for L=1:82 
                                cost = cost + data_set{1,year}(L,p)*data{1,year}(8,p);
                                V = V + data_set{1,year}(L,p)*data{1,year}(9,p);
                            end
                        else 
                            for L=55:82 %遍历每块地
                                cost = cost + data_set{1,year}(L,p)*data{1,year}(8,p);
                                V = V + data_set{1,year}(L,p)*data{1,year}(9,p);
                            end
                        end

                    end
                    % 计算两种模式下的收入
                    Ee = V - sales;             %供销差距
                    if Ee<=0                    % 未滞销     
                        income = income +  V*price;
                    else
                        if cond==1              %情况1：浪费
                            income = income + sales*price;
                        else                    %情况1：滞销部分50%售出
                            income = income + sales*price + 0.5*Ee*price;
                        end
                    end

                end
            end

        end
        obj(e,1) = income - cost; %计算该实验方案下某作物两季总净利润
    end
    OBJ(nind,1) = mean(obj); %计算各实验方案下某作物两季总净利润的均值
    OBJ(nind,2) = min(obj);  %计算各实验方案下某作物两季总净利润的最小值
end
end
function [obj]=nor_fitness(popu,data,cond)
obj = [];
for nind = 1:size(popu,2)
    data_set = popu{1,nind};
    % 计算收入
    income = 0;
    cost = 0;
    for year = 1:size(data_set,2) %遍历年份
        for s=1:2           %遍历季度
            for p=1:41      %遍历作物
                if s==1 %第一季度，只统计两季的
                    price = data(2,p); % 售价
                    sales=data(3,p);   %预计销售量
                    V = 0;              %产量
                    if p>=17 && p<=34
                        for L=1:55     %遍历每块地
                            area=data_set{1,year}(L,p);
                            cost = cost + area*data(4,p);
                            V = V + area*data(5,p);
                        end
                    else
                        continue
                    end
                    
                else
                    price = data(6,p);
                    sales=data(3,p);   %预计销售量
                    V = 0; %该产量
                    if p<17||p>34 %都是第二季收获的
                        for L=1:82 %遍历每块地
                            cost = cost + data_set{1,year}(L,p)*data(8,p);
                            V = V + data_set{1,year}(L,p)*data(9,p);
                        end
                    else %要去掉第一季的
                        for L=55:82 %遍历每块地
                            cost = cost + data_set{1,year}(L,p)*data(8,p);
                            V = V + data_set{1,year}(L,p)*data(9,p);
                        end
                    end
                end
                E = V - sales; %供销差距
                if E<=0          % 未滞销
                    income = income +  V*price;
                else            % 未滞销
                    if cond==1  %情况1：浪费
                        income = income + sales*price;
                    else        %情况1：滞销部分50%售出
                        income = income + sales*price + 0.5*E*price;
                    end
                end

            end
        end

    end
    obj(nind,1) = income - cost; %计算某作物两季总净利润
end
end
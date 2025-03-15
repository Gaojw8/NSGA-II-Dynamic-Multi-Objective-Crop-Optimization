data = xlsread('售价销量成本亩产表.xlsx');
Orthogonal = xlsread('正交实验表.xlsx');

E = cell(1,size(Orthogonal,1)); %建立方案元胞
for e=1:size(Orthogonal,1) %遍历每个方案
    E{1,e} = cell(1,7); %七年的数值
    for y=1:7
        E{1,e}{1,y} = data;
    end

    % 修改小麦、玉米销量年增长率
    E{1,e}{1,1}(7,6) = E{1,e}{1,1}(7,6)*(1+Orthogonal(e,2));
    E{1,e}{1,1}(7,6) = E{1,e}{1,1}(7,7)*(1+Orthogonal(e,2));
    for y=2:7
        E{1,e}{1,y}(7,6) = E{1,e}{1,y-1}(7,6)*(1+Orthogonal(e,2));
        E{1,e}{1,y}(7,7) = E{1,e}{1,y-1}(7,7)*(1+Orthogonal(e,2));
    end
    % 修改除小麦、玉米外销售量
    for p=1:41
        if p~=6 && p~=7 % 除小麦、玉米外
            for y=1:7
                E{1,e}{1,y}(3,p) = data(3,p)*(1+Orthogonal(e,3));
                E{1,e}{1,y}(7,p) = data(7,p)*(1+Orthogonal(e,3));
            end
        end
    end
    % 修改亩产量
    for p=1:41
        for y=1:7
            E{1,e}{1,y}(5,p) = data(5,p)*(1+Orthogonal(e,4));
            E{1,e}{1,y}(9,p) = data(9,p)*(1+Orthogonal(e,4));
        end
    end
    % 修改种植成本
    for p=1:41
        E{1,e}{1,1}(4,p) = E{1,e}{1,1}(4,p)*(1+Orthogonal(e,5));
        E{1,e}{1,1}(8,p) = E{1,e}{1,1}(8,p)*(1+Orthogonal(e,5));
        for y=2:7
            E{1,e}{1,y}(4,p) = E{1,e}{1,y-1}(4,p)*(1+Orthogonal(e,5));
            E{1,e}{1,y}(8,p) = E{1,e}{1,y-1}(8,p)*(1+Orthogonal(e,5));
        end
    end
    % 修改蔬菜价格年增长率
    for p=17:37
        E{1,e}{1,1}(2,p) = E{1,e}{1,1}(2,p)*(1+Orthogonal(e,6));
        E{1,e}{1,1}(6,p) = E{1,e}{1,1}(6,p)*(1+Orthogonal(e,6));
        for y=2:7
            E{1,e}{1,y}(2,p) = E{1,e}{1,y-1}(2,p)*(1+Orthogonal(e,6));
            E{1,e}{1,y}(6,p) = E{1,e}{1,y-1}(6,p)*(1+Orthogonal(e,6));
        end
    end
    % 修改食用菌价格年缩减率（除羊肚菌外）
    for p=38:40
        E{1,e}{1,1}(2,p) = E{1,e}{1,1}(2,p)*(1-Orthogonal(e,7));
        E{1,e}{1,1}(6,p) = E{1,e}{1,1}(6,p)*(1-Orthogonal(e,7));
        for y=2:7
            E{1,e}{1,y}(2,p) = E{1,e}{1,y-1}(2,p)*(1-Orthogonal(e,7));
            E{1,e}{1,y}(6,p) = E{1,e}{1,y-1}(6,p)*(1-Orthogonal(e,7));
        end
    end
    % 修改羊肚菌价格年缩减率
    for p=41:41
        E{1,e}{1,1}(2,p) = E{1,e}{1,1}(2,p)*(1-Orthogonal(e,8));
        E{1,e}{1,1}(6,p) = E{1,e}{1,1}(6,p)*(1-Orthogonal(e,8));
        for y=2:7
            E{1,e}{1,y}(2,p) = E{1,e}{1,y-1}(2,p)*(1-Orthogonal(e,8));
            E{1,e}{1,y}(6,p) = E{1,e}{1,y-1}(6,p)*(1-Orthogonal(e,8));
        end
    end
    % 确保没有负数
    for y=1:7
        for p=1:41
            for L=1:9
                if E{1,e}{1,y}(L,p)<0
                    E{1,e}{1,y}(L,p)=0;
                end
            end
        end

    end
end
save("E_Q2.mat",'E')
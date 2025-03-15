%% 生成替补、互补系数矩阵
%豆类(黄豆、黑豆、红豆、绿豆、爬豆、豇豆、刀豆、芸豆):1-5,17-19
%谷物(小麦、玉米、谷子、高粱、黍子、荞麦、莜麦、大麦、水稻):6-11,14-16
%根茎(土豆、红薯、白萝卜、红萝卜):20、13、36、37
%瓜果(南瓜、黄瓜、西红柿、茄子):12、29、21、22
%叶类蔬菜(菠菜、青椒、菜花、包菜、油麦菜、小青菜、生菜、辣椒、空心菜、黄心菜、芹菜、大白菜)
%23-28、30-35
%食用菌(榆黄菇、香菇、白灵菇、羊肚菌):38-41

% 豆类与谷物类                互补性中
% 豆类内部                    互补性低
% 豆类内部                    替代性中
% 豆类与根茎类、瓜果类          替代性低

% 谷物类与豆类                  互补性中
% 谷物类内部                    互补性低
% 谷物类内部                    替代性高
% 小麦与大麦、谷子与高粱         替代性中
% 谷物类与根茎类、瓜果类         替代性低

% 根茎类与豆类、谷物类           互补性中
% 根茎类内部                    互补性低
% 土豆与红薯、白萝卜与红萝卜      替代性中
% 根茎类与瓜果类、叶类蔬菜        替代性低

% 瓜果类与根茎类                 互补性中
% 瓜果类内部                    互补性低
% 黄瓜与西红柿、茄子            替代性中
% 瓜果类与叶类蔬菜              替代性低

% 叶类蔬菜与根茎类、瓜果类       互补性中
% 叶类蔬菜内部                  互补性低
% 叶类蔬菜内部                  替代性高
% 青椒与辣椒之间                替代性中
% 叶类蔬菜与瓜果类              替代性低

% 食用菌类与豆类、根茎类作物      互补性中
% 食用菌类内部                  互补性低
% 香菇与羊肚菌                  替代性高
% 榆黄菇和白灵菇                替代性中
% 食用菌类与蔬菜类              替代性低

clear;close all;clc
load('E_Q2.mat','E')
complement_rank=[0.01,0.005,0.001]; % 互补性设置等级；高（自己）、中、低
substitute_rank=[-0.02,-0.01,-0.005]; % 替代性设置等级；高、中、低

% complement_ratio=complement_rank(3)*ones(41);  % 奖励系数
% substitute_ratio=substitute_rank(3)*ones(41);   % 惩罚系数

complement_ratio=0*ones(41);  % 奖励系数
substitute_ratio=0*ones(41);   % 惩罚系数

% 作物组索引
beans = [1:5, 17:19];          % 豆类
grains = [6:11, 14:16];        % 谷物类
root_crops = [20, 13, 36, 37]; % 根茎类
fruits = [12, 29, 21, 22];     % 瓜果类
leafy_veg = [23:28, 30:35];    % 叶类蔬菜
mushrooms = [38:41];           % 食用菌类

% 循环填充矩阵
for i = 1:41
    % 设置互补性和替代性等级
    if ismember(i, beans)  % 豆类
        % 豆类自己互补性最高
        complement_ratio(i, i) = complement_rank(1);
        % 豆类与谷物类互补性中
        complement_ratio(i, grains) = complement_rank(2);
        % 豆类内部互补性低，替代性中
        complement_ratio(i, beans) = complement_rank(3);
        substitute_ratio(i, beans) = substitute_rank(2);
        % 豆类与根茎类、瓜果类替代性低
        substitute_ratio(i, [root_crops, fruits]) = substitute_rank(3);
    elseif ismember(i, grains)  % 谷物类
        % 谷物类自己互补性最高
        complement_ratio(i, i) = complement_rank(1);
        % 谷物类与豆类互补性中
        complement_ratio(i, beans) = complement_rank(2);
        % 谷物类内部互补性低，替代性高
        complement_ratio(i, grains) = complement_rank(3);
        substitute_ratio(i, grains) = substitute_rank(1);
        % 小麦与大麦、谷子与高粱替代性中
        if ismember(i, [6, 14]) % 小麦和大麦
            substitute_ratio(6, 14) = substitute_rank(2);
            substitute_ratio(14, 6) = substitute_rank(2);
        end
        if ismember(i, [9, 10]) % 谷子和高粱
            substitute_ratio(9, 10) = substitute_rank(2);
            substitute_ratio(10, 9) = substitute_rank(2);
        end
        % 谷物类与根茎类、瓜果类替代性低
        substitute_ratio(i, [root_crops, fruits]) = substitute_rank(3);
    elseif ismember(i, root_crops)  % 根茎类
        % 根茎类自己互补性最高
        complement_ratio(i, i) = complement_rank(1);
        % 根茎类与豆类、谷物类互补性中
        complement_ratio(i, [beans, grains]) = complement_rank(2);
        % 根茎类内部互补性低
        complement_ratio(i, root_crops) = complement_rank(3);
        % 土豆与红薯、白萝卜与红萝卜替代性中
        if ismember(i, [20, 13]) % 土豆和红薯
            substitute_ratio(20, 13) = substitute_rank(2);
            substitute_ratio(13, 20) = substitute_rank(2);
        end
        if ismember(i, [36, 37]) % 白萝卜和红萝卜
            substitute_ratio(36, 37) = substitute_rank(2);
            substitute_ratio(37, 36) = substitute_rank(2);
        end
        % 根茎类与瓜果类、叶类蔬菜替代性低
        substitute_ratio(i, [fruits, leafy_veg]) = substitute_rank(3);
    elseif ismember(i, fruits)  % 瓜果类
        % 瓜果类自己互补性最高
        complement_ratio(i, i) = complement_rank(1);
        % 瓜果类与根茎类互补性中
        complement_ratio(i, root_crops) = complement_rank(2);
        % 瓜果类内部互补性低
        complement_ratio(i, fruits) = complement_rank(3);
        % 黄瓜与西红柿、茄子替代性中
        if ismember(i, [29, 21, 22]) % 黄瓜、西红柿、茄子
            substitute_ratio(29, [21, 22]) = substitute_rank(2);
            substitute_ratio(21, [29, 22]) = substitute_rank(2);
            substitute_ratio(22, [29, 21]) = substitute_rank(2);
        end
        % 瓜果类与叶类蔬菜替代性低
        substitute_ratio(i, leafy_veg) = substitute_rank(3);
    elseif ismember(i, leafy_veg)  % 叶类蔬菜
        % 叶类蔬菜自己互补性最高
        complement_ratio(i, i) = complement_rank(1);
        % 叶类蔬菜与根茎类、瓜果类互补性中
        complement_ratio(i, [root_crops, fruits]) = complement_rank(2);
        % 叶类蔬菜内部互补性低，替代性高
        complement_ratio(i, leafy_veg) = complement_rank(3);
        substitute_ratio(i, leafy_veg) = substitute_rank(1);
        % 青椒与辣椒之间替代性中
        if ismember(i, [24, 30]) % 青椒和辣椒
            substitute_ratio(24, 30) = substitute_rank(2);
            substitute_ratio(30, 24) = substitute_rank(2);
        end
    elseif ismember(i, mushrooms)  % 食用菌类
        % 食用菌类自己互补性最高
        complement_ratio(i, i) = complement_rank(1);
        % 食用菌类与豆类、根茎类作物互补性中
        complement_ratio(i, [beans, root_crops]) = complement_rank(2);
        % 食用菌类内部互补性低
        complement_ratio(i, mushrooms) = complement_rank(3);
        % 香菇与羊肚菌替代性高，榆黄菇和白灵菇替代性中
        if ismember(i, [39, 41]) % 香菇和羊肚菌
            substitute_ratio(39, 41) = substitute_rank(1);
            substitute_ratio(41, 39) = substitute_rank(1);
        end
        if ismember(i, [38, 40]) % 榆黄菇和白灵菇
            substitute_ratio(38, 40) = substitute_rank(2);
            substitute_ratio(40, 38) = substitute_rank(2);
        end
        % 食用菌类与蔬菜类替代性低
        substitute_ratio(i, leafy_veg) = substitute_rank(3);
    end
end

%% 修改E
load('model.mat','net');
for e = 1:size(E, 2)
    for y = 1:size(E{1, e}, 2)
        for j = 1:size(E{1, e}{1, y}, 2)
            % 处理第一季度相关计算
            if E{1, e}{1, y}(2, j) ~= 0 && E{1, e}{1, y}(4, j) ~= 0
                E{1, e}{1, y}(3, j) = myFun2(E{1, e}{1, y}(2, j), E{1, e}{1, y}(4, j),net);

                % 加入互补性和替代性影响（作物之间的收益/成本修正）
                for k = 1:size(E{1, e}{1, y}, 2) % 遍历其他作物
                    E{1, e}{1, y}(3, j) = E{1, e}{1, y}(3, j) + complement_ratio(j, k) * E{1, e}{1, y}(3, k) + substitute_ratio(j, k) * E{1, e}{1, y}(3, k);
                end
                % 确保收益不为负数
                if E{1, e}{1, y}(3, j) < 0
                    E{1, e}{1, y}(3, j) = 0;
                end
            end

            % 处理第二季度相关计算
            if E{1, e}{1, y}(6, j) ~= 0 && E{1, e}{1, y}(8, j) ~= 0
                E{1, e}{1, y}(7, j) = myFun2(E{1, e}{1, y}(6, j), E{1, e}{1, y}(8, j),net);
                % 加入互补性和替代性影响（作物之间的收益/成本修正）
                for k = 1:size(E{1, e}{1, y}, 2) % 遍历其他作物
                    E{1, e}{1, y}(7, j) = E{1, e}{1, y}(7, j) + complement_ratio(j, k) * E{1, e}{1, y}(7, k) + substitute_ratio(j, k) * E{1, e}{1, y}(7, k);
                end
                % 确保收益不为负数
                if E{1, e}{1, y}(7, j) < 0
                    E{1, e}{1, y}(7, j) = 0;
                end
            end
        end
    end
end

save("E_Q3.mat",'E')

function z = myFun2(x, y,model)
    inp=[x,y]';
    z=model(inp);
end


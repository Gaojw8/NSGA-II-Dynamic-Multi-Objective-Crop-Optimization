function [selected_popu,selected_obj]=NSGA_selection(popu,obj,NIND)
     n = size(obj, 2);      % 种群大小
    P = 1:n;                % 种群的索引
    front = cell(n, 1);     % 用于保存不同层的前沿
    rank = zeros(1, n);     % 个体的帕累托等级
    crowd_dist = zeros(1, n); % 个体的拥挤度距离
    
    % 计算支配关系
    S = cell(1, n); % 个体i支配的个体集合
    n_p = zeros(1, n); % 个体i被支配的数量
    for i = 1:n
        S{i} = [];
        n_p(i) = 0;
        for j = 1:n
            if i ~= j
                if dominates(obj(:, i), obj(:, j))
                    S{i} = [S{i}, j];
                elseif dominates(obj(:, j), obj(:, i))
                    n_p(i) = n_p(i) + 1;
                end
            end
        end
        if n_p(i) == 0
            rank(i) = 1;
            front{1} = [front{1}, i];
        end
    end
    
    % 分层
    i = 1;
    while ~isempty(front{i})
        Q = [];
        for j = 1:length(front{i})
            p = front{i}(j);
            for q = S{p}
                n_p(q) = n_p(q) - 1;
                if n_p(q) == 0
                    rank(q) = i + 1;
                    Q = [Q, q];
                end
            end
        end
        i = i + 1;
        front{i} = Q;
    end
    
    % 计算拥挤度距离
    for i = 1:(i - 1)
        crowd_dist = calculate_crowding_distance(obj, front{i}, crowd_dist);
    end
    
    % 根据非支配排序和拥挤度距离选择个体
    selected_indices = [];
    i = 1;
    while length(selected_indices) + length(front{i}) <= NIND
        selected_indices = [selected_indices, front{i}];
        i = i + 1;
    end
    % 如果最后一层选不完整，根据拥挤度距离选择
    if length(selected_indices) < NIND
        [~, order] = sort(crowd_dist(front{i}), 'descend');
        selected_indices = [selected_indices, front{i}(order(1:(NIND - length(selected_indices))))];
    end
    
    % 生成选择后的种群
    selected_popu = popu(selected_indices);
    selected_obj = obj(:,selected_indices);
    selected_obj = selected_obj';
end

%% 下面是子函数

% 检查个体x是否支配个体y
function is_dom = dominates(x, y)
    is_dom = all(x >= y) && any(x > y);
end

% 计算拥挤度距离
function crowd_dist = calculate_crowding_distance(obj, front, crowd_dist)
    l = length(front);
    if l == 0
        return;
    end
    M = size(obj, 1); % 目标数量
    distances = zeros(l, M);
    for m = 1:M
        [~, order] = sort(obj(m, front));
        f_sorted = front(order);
        distances(1, m) = inf;
        distances(end, m) = inf;
        for k = 2:l-1
            distances(k, m) = distances(k, m) + (obj(m, f_sorted(k+1)) - obj(m, f_sorted(k-1)));
        end
    end
    crowd_dist(front) = sum(distances, 2)';


end
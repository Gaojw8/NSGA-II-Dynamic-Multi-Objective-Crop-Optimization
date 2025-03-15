function [topIndividuals,sortedFitness]=nor_selection(popu,obj,NIND)
    [sortedFitness, sortedIndex] = sort(obj, 'descend');  % 按适应度降序排序，并获取排序后的索引  
    topIndividuals = popu(sortedIndex(1:NIND));  % 选择适应度最大的 NIND 个个体  
end
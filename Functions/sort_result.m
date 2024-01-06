function [SortedDataset, SortedValues] = sort_result(Dataset, choice)
    
    values = zeros(numel(Dataset),1);
   
    for index = 1:numel(Dataset)
        fieldName = sprintf('Dataset{%d}.%s', index, choice);
        values(index) = eval(fieldName);
    end
    
    [~, sortedIndices] = sort(values);
    
    SortedDataset = Dataset(sortedIndices);
    SortedValues = values(sortedIndices);
end
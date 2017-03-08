function     [NewCombinationList] = GroundTruthFinalTrialToNCL(FinalTrial, AllCombinations)

if ~strcmp(FinalTrial, 'First')
    Code        = str2double(cell2mat((cellstr(FinalTrial(4:10)))));
    Inter       = str2double(cellstr(FinalTrial(21)));
    VD          = str2double(cellstr(FinalTrial(14:16)));
    Trial       = str2double(cellstr(FinalTrial(24:25)));
    
    LastOne  = find(AllCombinations(:,1)==Code & AllCombinations(:,2)==VD & AllCombinations(:,3)==Inter & AllCombinations(:,4)==Trial);
    NewCombinationList = AllCombinations(LastOne:end,:);
else
    NewCombinationList = AllCombinations
end
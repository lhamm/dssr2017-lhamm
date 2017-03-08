function  [FinalTrial]  = GroundTruthStart(Strategy, StrategyList, Legitimacy)

LastOne                 = cell(200,1);
if Legitimacy == 1
    AnalysisData        = 'AnalysisData';
else if Legitimacy == 2
        AnalysisData    = 'Dummy';
    end
end

AnalysisFileRoot                = GetPathSpecificToUser('Desktop','dssr2017-lhamm',AnalysisData, sprintf('%s',StrategyList{Strategy}));
AnalysisFiles                   = dir(sprintf('%sCodeCorrectLocation*.mat',AnalysisFileRoot));

if ~isempty(AnalysisFiles)     %check that there is data in the folder
    for i=1:length(AnalysisFiles)
        a           = open(AnalysisFiles(i).name);
        if ~isempty(a)          % check that there is data in the data file
            A       = find(cellfun('isempty', a.CorrectPositionStore),1);
                LastOne{i}=(a.CorrectPositionStore{A-1,5});
            if isempty(LastOne{i})    
                LastOne{i}=(a.CorrectPositionStore{A-1,4});
            end
            
        end
    end
end

FinalInd        = find(cellfun('isempty', LastOne), 1);
try
    FinalTrial  = LastOne{FinalInd-1};
catch
    FinalTrial  = 'First';
end


function [SumD, SumDUnique] = WhatIsDoneAlready(Strategy, StrategyList, Position)
%Find files in approriate folder and list completed files in order
% 5th position in SumD is for Bullseye, and 6th is for Eye

%% Tests:
% has been tested on empty folders, empty data files, and existing data, as we would expect most of the time

AnalysisFileRoot            = GetPathSpecificToUser('Desktop','dssr2017-lhamm','AnalysisData', sprintf('%s',StrategyList{Strategy}));
AnalysisFiles               = dir(sprintf('%sDataAnalysis*.dat',AnalysisFileRoot));
cnt                         = 0;
if ~isempty(AnalysisFiles)      %check that there is data in the folder
    for i=1:length(AnalysisFiles)
        a=importdata(AnalysisFiles(i).name); 
        if ~isempty(a)          % check that there is data in the data file
            for j=1:length(a.data);
                b=char(a.textdata(j)) ;
                cnt=cnt+1;
                    SumD(cnt,1)=str2double(b(4:10)); SumD(cnt,2) =str2double(b(14:16)); SumD(cnt,3) = str2double(b(21)); SumD(cnt,4) = str2double(b(24:25)); SumD(cnt,Position)=a.data(j);
            end
        end
    end
else
    SumD=NaN(1,6);              % ensure that if there is no data, that we still have an output
end


SumD=sort(SumD);
SumDUnique=unique(SumD, 'rows');

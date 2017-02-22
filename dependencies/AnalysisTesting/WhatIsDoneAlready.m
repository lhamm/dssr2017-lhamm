function [SumD, SumDUnique] = WhatIsDoneAlready(Strategy, StrategyList, DorENum)
%Find files in approriate folder and list completed files in order
%LISATODO: deal with DorENum - so we get a list of only those which were
%looking at the specified paratmeter

%% Needs to be tested!

AnalysisFileRoot            = GetPathSpecificToUser('Desktop','dssr2017-lhamm','AnalysisData', sprintf('%s',StrategyList{Strategy}));
AnalysisFiles               = dir(sprintf('%sDataAnalysis*.dat',AnalysisFileRoot));
cnt                         = 0;

if ~isempty(AnalysisFiles)
    for i=1:length(AnalysisFiles)
        a=importdata(AnalysisFiles(i).name);
        for j=1:length(a.data);
            b=char(a.textdata(j)) ;
            cnt=cnt+1;
            SumD(cnt,1)=str2double(b(4:10)); SumD(cnt,2) =str2double(b(14:16)); SumD(cnt,3) = str2double(b(21)); SumD(cnt,4) = str2double(b(24:25)); SumD(cnt,5)=a.data(j);
            % categorize with BullsEye or Eye here
        end
    end
else
    SumD=NaN(1,5);
end


SumD=sort(SumD);
SumDUnique=unique(SumD, 'rows');

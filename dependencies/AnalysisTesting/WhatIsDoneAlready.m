function [SumD, SumDUnique] = WhatIsDoneAlready(Strategy, StrategyList, Position)
%Find files in approriate folder and list completed files in order
% 5th position in SumD is for Bullseye, and 6th is for Eye

%% Tests:
% has been tested on empty folders, empty data files, and existing data, as we would expect most of the time
% checked that it will work on random selections after Eye or Bullseye
% in 

AnalysisFileRoot            = GetPathSpecificToUser('Desktop','dssr2017-lhamm','AnalysisData', sprintf('%s',StrategyList{Strategy}));
if Position==5
    Type=1;
elseif Position==6
    Type=2;
end
AnalysisFiles               = dir(sprintf('%sDataAnalysis_%i_%i*.dat',AnalysisFileRoot, Strategy, Type));
cnt                         = 0;
if ~isempty(AnalysisFiles)      %check that there is data in the folder
    for i=1:length(AnalysisFiles)
        a=importdata(AnalysisFiles(i).name); 
        if ~isempty(a)          % check that there is data in the data file
            for j=1:length(a.data);
                b=char(a.textdata(j)) ;
                cnt=cnt+1;
                    SumD(cnt,1)=str2double(b(4:10)); SumD(cnt,2) =str2double(b(14:16)); SumD(cnt,3) = str2double(b(21)); SumD(cnt,4) = str2double(b(24:25)); SumD(cnt,Position)=a.data(j,Type);
                    if Position==5
                        SumD(cnt,6)=NaN;
                    elseif Position==6
                        SumD(cnt,5)=NaN;
                    end
            end
        else
           % SumD=NaN(1,5);
        end
    end
end

if ~exist('SumD','var')
    SumD=NaN(1,5);              % ensure that if there is no data, that we still have an output
end

SumD=sort(SumD);
SumD(isnan(SumD)) = Inf; %unique can't deal with NaN, but can with Inf
SumDUnique=unique(SumD, 'rows');
% change both back to NaNs
SumD(SumD==Inf)= NaN; 
SumDUnique(SumDUnique==Inf)=NaN;

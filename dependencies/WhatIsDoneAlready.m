function [SumD] = WhatIsDoneAlready(Strategy, StrategyList)
%Find files in approriate folder and list them in order

    AnalysisFileRoot            = GetPathSpecificToUser('Desktop','dssr2017-lhamm','AnalysisData', sprintf('%s',StrategyList{Strategy}));
    AnalysisFiles               = dir(sprintf('%sDataAnalysis*.dat',AnalysisFileRoot));
    cnt                         = 0;
    %SumD                        = NaN(1,5);
    for i=1:length(AnalysisFiles)
        try %this try catch loop deals with blank data files
            a=importdata(AnalysisFiles(i).name);
            for j=1:length(a.data);
                b=char(a.textdata(j)) ;
                cnt=cnt+1;
                SumD(cnt,1)=str2double(b(4:10)); SumD(cnt,2) =str2double(b(14:16)); SumD(cnt,3) = str2double(b(21)); SumD(cnt,4) = str2double(b(24:25)); SumD(cnt,5)=a.data(j);
                SumD=sort(SumD);
            end
        catch
        end
    end



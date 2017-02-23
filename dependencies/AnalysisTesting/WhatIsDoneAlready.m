function [SumD, SumDUnique] = WhatIsDoneAlready(Strategy, StrategyList, Position)
%Find files in approriate folder and list completed files in order
% 5th position in SumD is for Bullseye, and 6th is for Eye

%% Tests:
% has been tested on empty folders, empty data files, and existing data, as we would expect most of the time
% checked that it will work on random selections after Eye or Bullseye
% in 

AnalysisFileRoot            = GetPathSpecificToUser('Desktop','dssr2017-lhamm','AnalysisData', sprintf('%s',StrategyList{Strategy}));
%which tests are we doing?
if Position==5
    Type=1;
elseif Position==6
    Type=2;
end

AnalysisFiles               = dir(sprintf('%sDataAnalysis_%i_%i*.dat',AnalysisFileRoot, Strategy, Type));
MissingDataFiles            = dir(sprintf('%sDataAnalysis_%i_%i*.txt',AnalysisFileRoot, Strategy, Type));

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
%% now check for missing files: Work on this - it is close, I'm up to line 51
% if ~isempty(MissingDataFiles)      %check that there is data in the folder
%     for i=1:length(MissingDataFiles)
%         Data=importdata(MissingDataFiles(i).name);
%         if ~isempty(Data)          % check that there is data in the data file
%             MissData        = char(Data(1));
%             if length(MissData)>20 %more than the titles
%                 cnt=cnt+1;
%                 MissDataName    = MissData(1,(end-18:end-12));
%                 MissDataVD      = MissData(1,(end-9:end-7));
%                 SumD(cnt:cnt+64,1)=str2double(MissDataName); SumD(cnt:cnt+64,2)=str2double(MissDataVD);SumD(cnt:cnt+16,3)=1;SumD(cnt+16:cnt+32,3)=2;SumD(cnt:cnt+48,3)=3;SumD(cnt+16:cnt+64,3)=4;
%                 SumD(cnt:cnt+16, 4)=1:16; SumD(cnt+16:cnt+32, 4)=1:16; SumD(cnt+32:cnt+48, 4)=1:16; SumD(cnt+48:cnt+64, 4)=1:16;
%             end
%                 MissImage       = char(Data(2));
%                 
%                 b=char(a.textdata(j)) ;
%                 cnt=cnt+1;
%                 SumD(cnt,1)=str2double(b(4:10)); SumD(cnt,2) =str2double(b(14:16)); SumD(cnt,3) = str2double(b(21)); SumD(cnt,4) = str2double(b(24:25)); SumD(cnt,Position)=a.data(j,Type);
%                 if Position==5
%                     SumD(cnt,6)=NaN;
%                 elseif Position==6
%                     SumD(cnt,5)=NaN;
%                 end
%             else
%                 % SumD=NaN(1,5);
%             end
%         end
% 
% end

%% 

if ~exist('SumD','var')
    SumD=NaN(1,5);              % ensure that if there is no data, that we still have an output
end

%% now order, and only look at unique files

SumD=sort(SumD);
SumD(isnan(SumD)) = Inf; %unique can't deal with NaN, but can with Inf
SumDUnique=unique(SumD, 'rows');
% change both back to NaNs
SumD(SumD==Inf)= NaN; 
SumDUnique(SumDUnique==Inf)=NaN;

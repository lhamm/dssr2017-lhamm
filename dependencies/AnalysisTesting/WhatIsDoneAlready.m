function [SumD, SumDUnique] = WhatIsDoneAlready(Strategy, StrategyList, Position, Legitimacy)
%Find files in approriate folder and list completed files in order
% 5th position in SumD is for Bullseye, and 6th is for Eye

%% Tests:
% has been tested on empty folders, empty data files, and existing data, as we would expect most of the time
% checked that it will work on random selections after Eye or Bullseye
% in

if Legitimacy == 1
        AnalysisData = 'AnalysisData';
else if Legitimacy == 2
    AnalysisData = 'Dummy';
    end
end

AnalysisFileRoot            = GetPathSpecificToUser('Desktop','dssr2017-lhamm',AnalysisData, sprintf('%s',StrategyList{Strategy}));

%which tests are we doing?
if Position==5
    Type=1; % bulls eye
elseif Position==6
    Type=2; % eye
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
%% now check for missing files: Work on this - it is close, I'm up to line 51
MissingDataFiles            = dir(sprintf('%sDataAnalysis_%i_%i*DATA.txt',AnalysisFileRoot, Strategy, Type));
if ~isempty(MissingDataFiles)      %check that there is data in the folder
    for i=1:length(MissingDataFiles)
        Data=importdata(MissingDataFiles(i).name);
        if ~isempty(Data)          % check that there is data in the data file
            for j=1:length(Data)
            MissData        = char(Data(j));
          %  if length(MissData)>20 %more than the titles
                cnt=cnt+1;
                MissDataName    = strjoin(cellstr(MissData(1,(end-18:end-12))));
                MissDataVD      = strjoin(cellstr(MissData(1,(end-9:end-7))));
                SumD(cnt:cnt+63,1) = str2double(MissDataName);
                SumD(cnt:cnt+63,2) = str2double(MissDataVD);
                SumD(cnt:cnt+15,3) = 1;SumD(cnt+16:cnt+31,3)=2;SumD(cnt+32:cnt+47,3)=3;SumD(cnt+48:cnt+63,3)=4;
                SumD(cnt:cnt+15,4) = 1:16; SumD(cnt+16:cnt+31, 4)=1:16; SumD(cnt+32:cnt+47, 4)=1:16; SumD(cnt+48:cnt+63, 4)=1:16;
                SumD(cnt:cnt+63,5:6) = NaN;
            end
        end
    end
end

MissingImageFiles           = dir(sprintf('%sDataAnalysis_%i_%i*IMAGE.txt',AnalysisFileRoot, Strategy, Type));           
if ~isempty(MissingImageFiles)
    for i=1:length(MissingImageFiles)
        Image=importdata(MissingImageFiles(i).name);
        if ~isempty(Image)
            for j=1:length(Image)
            MissImage       = char(Image(j));
            % if length(MissImage)>20
            cnt=cnt+1;
            MissImageName    = str2double(strjoin(cellstr(MissImage(1,(end-27:end-21)))));
            MissImageVD      = str2double(strjoin(cellstr(MissImage(end-17:end-15))));
            MissImageInter   = str2double(MissImage(end-10));
            MissImageTrial   = str2double(strjoin(cellstr(MissImage(end-7:end-6))));
            SumD(cnt,1) = MissImageName;
            SumD(cnt,2) = MissImageVD;
            SumD(cnt,3) = MissImageInter;
            SumD(cnt,4) = MissImageTrial;
            SumD(cnt,5:6) = NaN;
            end
        end
    end
end

%% 

if ~exist('SumD','var')
    SumD=NaN(1,5);              % ensure that if there is no data, that we still have an output
end

%% now order, and only look at unique files

%SumD=sort(SumD);
SumD(isnan(SumD)) = Inf; %unique can't deal with NaN, but can with Inf
SumDUnique=unique(SumD, 'rows');
% change both back to NaNs
SumD(SumD==Inf)= NaN; 
SumDUnique(SumDUnique==Inf)=NaN;

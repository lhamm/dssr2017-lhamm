%% This script is designed to look at saved images containing bullseyes as well as data files containing information about these images
%intro (name of program, name of authors, descriptions)

clearvars
close all
format long g
rng('shuffle')
Done=0;

%% initialise
AnalysisVersion             = 2.0; % 1.3 = change how eyes were stored and fixed tracking/detecting numbers
TestingVersion              = 1.0; % update as we use new data files

%% Ask user for input
ReasearchAssistants = {'KM', 'LH'};
RANum               = centmenu('Who are you?', ReasearchAssistants);
RA                  = ReasearchAssistants{RANum};

DistanceOrEye       = {'BullsEye', 'WhichEye'};
DorENum             = centmenu('What are you looking at?',DistanceOrEye); %1=BullsEye, 2=Eye
DorE                = DistanceOrEye{DorENum};


%% strategies for coding accuracy:
% LISATODO: could make a separate function for this: [StrategyName, StrategyNumber]  =GetStrategy
StrategyList                = {'SpecificSample', 'RandGenSample', 'AllNewDetects','OnlyWhenEyeDetected'};

if DorENum==1
    Strategy                = 2;
% SpecificSample              = 0; % if 1, just a test, if 0, run all through
% RandGenSample               = 0; % does all frames of one near and one distance at a particular trial number and inter for one participant
% AllNewDetects               = 1; % none of these have width est or eye
else
   Strategy                 = 4 ;
end

% if SpecificSample
%     Strategy                = 1;
% elseif RandGenSample
%     Strategy                = 2;
% elseif AllNewDetects
%     Strategy                = 3;
% end


    
LookAtFiles                 = 1; %if 1 will show a summary so far

%% initialise variables
OptNames                    = {'Flower', 'Car', 'Butterfly','Rocket','Duck','Heart','House','Moon','Tree','Rabbit'};
FileRoot                    = GetPathSpecificToUser('Documents','GUINZData');
[Obs, VD, Eyes, Stim]       = GetDataTypeListsGUINZ(FileRoot);
MaxFrames                   = GetMaxFrames(FileRoot, Obs, '.jpg');
Inter                       = 1:(length(Eyes)+length(Stim));
Trial                       = 1:16;
IndexList                   = NaN(length(Obs), MaxFrames, length(Trial), length(Inter), length(VD));
InterSeq                    = horzcat(ones(1,16), repmat(2,1,16), repmat(3,1,16), repmat(4,1,16));
TrialSeq                    = repmat([1:16],1,4);
MissingDataFiles            = '';
MissingImageFiles           = '';
FrameCounter                = 0;


%% Look at existing files
% Find combinations alredy tested
if LookAtFiles
    AnalysisFileRoot            = GetPathSpecificToUser('Desktop','dssr2017-lhamm','AnalysisData', sprintf('%s',StrategyList{Strategy})); %LISATODO: add one more variable for testing strategy
    AnalysisFiles               = dir(sprintf('%sDataAnalysis*.dat',AnalysisFileRoot));
    cnt=0;
    clear i
    for i=1:length(AnalysisFiles)
        %try
        a=importdata(AnalysisFiles(i).name);
        for j=1:length(a.data);
            b=char(a.textdata(j)) ;
            cnt=cnt+1;
            SumD(cnt,1)=str2double(b(4:10)); SumD(cnt,2) =str2double(b(14:16)); SumD(cnt,3) = str2double(b(21)); SumD(cnt,4) = str2double(b(24:25)); SumD(cnt,5)=a.data(j);
        end
        %catch
        %end
    end
end

%% get new list of images to test
if Strategy==1 %chose which files you want to look at
    Obs                     = Obs(12:13); %chose a number
    VD                      = VD(1); %chose a number
    Eyes                    = Eyes{1}; %chose a number
    Stim                    = Stim{1}; %chose a number
    Inter                   = 1; %chose a number....this is related to last 2...
elseif Strategy==2 %LISATODO: use information from what we already have rather than truely random
    ObsList                 = randi(length(Obs),1); %need this for indexing
    Obs                     = (Obs(ObsList));
    Inter                   = randi(4,1);  %need this for indexing
    Trial                   = randi(16,1);
    % use both VDs
    % write something so that it does not do files which are already done -
    % tricky because random....think about this
elseif Strategy==3
    lastFile=SumD(end,1:4); %these are in order, so let's find the last one we were working on
    ind=find(str2double(Obs)==lastFile(1,1));
    if ind>=length(Obs)-1;
        centmenu('You are done!!',{'woohoo'})
        Done=1;
    else
        Obs=Obs(ind+1:ind+2); % make Obs now only be that file on (assuming it was incomplete)
    end
end %default is to go through all of them

if ~Done
    %% set up for graph
    dependentvar                 = sprintf('Outcome of "%s" analysis strategy ', StrategyList{Strategy});
    independentvar               = sprintf('Proportion of frames in each category (out of %i)', length(SumD));
    PossErrorTypes               = {'Perfect, looks sensible', 'BullsEye out of frame', 'Child obscuring bullsEye', 'BullsEye, but no rect', 'Wrong Position', 'Position OK, no width', 'Width est, wrong position'};
    
    %% set up log file for test run
    FileName            = sprintf('DataAnalysis_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s.dat', Strategy, AnalysisVersion, TestingVersion, MyDate, RA);
    % currently displays in the location you ran it from - try to move to
    % correct folder automatically
    fileID              = fopen(FileName,'w');
    formatSpec          = '%s %i %i \n';
    
    %try
    %% start loop
    % TODO: make a random list for testing
    for ObsLoop=1:numel(Obs) %observers or participants who have image files
        ImageFolderName=sprintf('%s%c',Obs{ObsLoop},filesep);
        for VDLoop=1:length(VD); %viewing distance
            DataCode        = sprintf('%sDataFiles%c%sVD%0.1f_*.mat ',FileRoot, filesep, Obs{ObsLoop},VD(VDLoop));
            flist           = dir(DataCode);
            if isempty(flist)
                MissingDataFiles=strcat(MissingDataFiles, DataCode);
            else
                DataFile        = open(strcat(sprintf('%sDataFiles%c',FileRoot, filesep),(flist(1).name)));
                
                for InterLoop=1:length(Inter) %Test: RE regular, RE vanishing, LE Regular, LE vanishing
                    if Strategy==3
                        TrialNo=length(Trial);
                    else
                        TrialNo=length(DataFile.S_Data.SizeDisplayed(Inter(InterLoop),:)); %number of trials in that test
                    end
                    for TrialLoop=1:TrialNo;
                        % do pal fits and bootstrapping to get acuity and reliability data
                        SeqTrialInd=find(TrialSeq==Trial(TrialLoop));
                        SeqInd=SeqTrialInd(Inter(InterLoop));
                        MaxFrameNumberPerTrial=find(diff(~isnan(DataFile.S_Data.FrameTimingRecord(SeqInd,:)))==(-1)); %or sum(~isnan(DataFile.S_Data.FrameTimingRecord(InterLoop*TrialLoop,:)));
                        for FrameLoop=1:MaxFrameNumberPerTrial %need data file not image yet- linking to image later
                            if mod(FrameLoop, 6)==0 %every 6th frame we took an image
                                ImageCode       = dir(strcat(FileRoot, ImageFolderName,sprintf('%s_%0.1f_%i_%i_%i_*.jpg', Obs{ObsLoop}, VD(VDLoop), Inter(InterLoop), Trial(TrialLoop)-1, FrameLoop)));
                                if isempty(ImageCode)
                                    MissingImageFiles=strcat(MissingImageFiles, ImageCode);
                                else
                                    %%LisaTODO - tidy up flow here...
                                    if Strategy==3;
                                        if ~DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, FrameLoop)
                                            FullImageName       = strcat(FileRoot, ImageFolderName, ImageCode.name);
                                            Im                  = imread(FullImageName);
                                            [BEResult]          = CompareDataToImGUINZ(DataFile, Im, ImageCode.name,Inter(InterLoop), Trial(TrialLoop), SeqInd, FrameLoop, PossErrorTypes,OptNames);
                                            FrameCounter=FrameCounter+1;
                                            close all
                                            % do eye analysis
                                            EyeResult=NaN;
                                            SimpleCode=sprintf('Obs%s_VD%03dcm_I%i_T%02d_F%04d', Obs{ObsLoop}, VD(VDLoop)*100, Inter(InterLoop), Trial(TrialLoop), FrameLoop);
                                            % save into one cell Matrix
                                            Summary{FrameCounter,1}=SimpleCode;Summary{FrameCounter,2}=BEResult;Summary{FrameCounter,3}=NaN;
                                        end
                                    else
                                        FullImageName   = strcat(FileRoot, ImageFolderName, ImageCode.name);
                                        Im              = imread(FullImageName);
                                        [BEResult]       = CompareDataToImGUINZ(DataFile, Im, ImageCode.name,Inter(InterLoop), Trial(TrialLoop), SeqInd, FrameLoop, PossErrorTypes,OptNames);
                                        FrameCounter=FrameCounter+1;
                                        close all
                                        % do eye analysis
                                        EyeResult=NaN;
                                        SimpleCode=sprintf('Obs%s_VD%03dcm_I%i_T%02d_F%04d', Obs{ObsLoop}, VD(VDLoop)*100, Inter(InterLoop), Trial(TrialLoop), FrameLoop);
                                        % save into one cell Matrix
                                        Summary{FrameCounter,1}=SimpleCode; Summary{FrameCounter,2}=BEResult;Summary{FrameCounter,3}=NaN;
                                    end
                                end %end of the if missing image part
                            end
                        end
                    end
                end
            end %end of if missing data
        end
    end
    [nrows,ncols] = size(Summary);
    for row = 1:nrows
        fprintf(fileID,formatSpec,Summary{row,:});
    end
    fclose(fileID);
    %catch
    %end
    %% Plot!
    if LookAtFiles
        AllResults          = [sum(SumD(:,5)==1), sum(SumD(:,5)==2), sum(SumD(:,5)==3), sum(SumD(:,5)==4), sum(SumD(:,5)==5), sum(SumD(:,5)==6), sum(SumD(:,5)==7)];
        TotalFramesOverTime = sum(AllResults);
        Proportion          = AllResults/TotalFramesOverTime;
        labelledBar(PossErrorTypes, Proportion, independentvar, dependentvar)
    end
end %skip all if done



%% This script is designed to look at saved images containing bullseyes as well as data files containing information about these images
%intro (name of program, name of authors, descriptions)
clearvars
close all
format long g
rng('shuffle')

%% initialise frequently changing variables
AnalysisVersion     = 2.1; %2.1=eye analysis added in; 1.3 = change how eyes were stored and fixed tracking/detecting numbers
TestingVersion      = 1.0; % update as we use new data files
LookAtFiles         = 1; %if 1 will show a summary so far

%% Ask user for input
ReasearchAssistants = {'KM', 'LH'};
RANum               = centmenu('Who are you?', ReasearchAssistants);
RA                  = ReasearchAssistants{RANum};

DistanceOrEye       = {'BullsEye', 'WhichEye'};
DorENum             = centmenu('What are you looking at?',DistanceOrEye); %1=BullsEye, 2=Eye
DorE                = DistanceOrEye{DorENum};

StrategyList        = {'SpecificSample', 'RandGenSample', 'AllNewDetects','OnlyWhenEyeDetected'};
Strategy            = centmenu('What strategy do tyou want to take?', StrategyList);
if Strategy>1
    NumberOfTrials  = centmenu('How many trials do you want to code?', {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'});
else
    NumberOfTrials  = 1;
end

if DorENum==1;
    PossErrorTypes  = {'Perfect, looks sensible', 'BullsEye out of frame', 'Child obscuring bullsEye', 'BullsEye, but no rect', 'Wrong Position', 'Position OK, no width', 'Width est, wrong position'};
    Position=5;
else
    PossErrorTypes  = {'Perfect, CorPatch, CorID', 'BullsEye out of frame','Child obscuring bullsEye', 'CorPatch, WrongID', 'WrongPatch, CorID','WrongPatch, WrongID','No Eye RectWrong', 'No Eye RectCorrect','Eye est, wrong position'};
    Position=6;
end 
    

%% initialise variables - could make a structure containing these fields
FileRoot                    = GetPathSpecificToUser('Documents','GUINZData');
[Obs, VD, Eyes, Stim]       = GetDataTypeListsGUINZ(FileRoot);
AllCombinations             = allcomb(str2double(Obs), VD*100, 1:4, 1:16);
MaxFrames                   = GetMaxFrames(FileRoot, Obs, '.jpg');

OptNames                    = {'Flower', 'Car', 'Butterfly','Rocket','Duck','Heart','House','Moon','Tree','Rabbit'};
InterSeq                    = horzcat(ones(1,16), repmat(2,1,16), repmat(3,1,16), repmat(4,1,16));
TrialSeq                    = repmat([1:16],1,4);
MissingDataFiles            = ''; 
MissingImageFiles           = '';
Done                        = 0;
FrameCounter                = 0;
Summary                     = cell(1,3);

%% Look at existing files and choose new ones
[SumD, SumDUnique]          = WhatIsDoneAlready(Strategy, StrategyList, Position);
if isnan(SumD(1,1))
    NewCombinationList      = AllCombinations; %nothing yet, start with all options
else
    NewCombinationList      = WhatIsLeftToDo(AllCombinations,SumDUnique); % LISATODO - deal with case - you're done!
end

if isempty(NewCombinationList) %if it is done, I'm not sure if it will crash on the earlier line, or if this will do the trick - test!
    Done=1;
else
    [Obs, VD, Inter, Trial] = ChooseFramesToTest(NewCombinationList, Strategy, NumberOfTrials);
end

if ~Done
    %% set up log file for test run
    FileName            = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s.dat', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA);
    FileNameLog         = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s.txt', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA);
    % LISATODO: currently displays in the location you ran it from - try to move t
    
    %try
    %% start loop
    for i=1:NumberOfTrials
        ImageFolderName                         = sprintf('%s%c',Obs{i},filesep);
        DataCode                                = sprintf('%sDataFiles%c%sVD%0.1f_*.mat ',FileRoot, filesep, Obs{i},VD(i));
        flist                                   = dir(DataCode);
        if isempty(flist)
            MissingDataFiles                    = strcat(MissingDataFiles, DataCode);
        else
            DataFile                            = open(strcat(sprintf('%sDataFiles%c',FileRoot, filesep),(flist(1).name)));
            SeqTrialInd                         = find(TrialSeq==Trial(i));
            SeqInd                              = SeqTrialInd(Inter(i));
            MaxFrameNumberPerTrial              = find(diff(~isnan(DataFile.S_Data.FrameTimingRecord(SeqInd,:)))==(-1)); %or sum(~isnan(DataFile.S_Data.FrameTimingRecord(InterLoop*TrialLoop,:)));
            FrameList                           = 6:6:MaxFrameNumberPerTrial;
            for j=1:length(FrameList) %can't do this because  we need a 1 by 1 counter from frames - do it like before instead.
                ImageCode                       = dir(strcat(FileRoot, ImageFolderName,sprintf('%s_%0.1f_%i_%i_%i_*.jpg', Obs{i}, VD(i), Inter(i), Trial(i)-1, FrameList(j))));
                if isempty(ImageCode)
                    MissingImageFiles           = strcat(MissingImageFiles, ImageCode);
                else
                    %% LISATODO: make a function
                    if Strategy==1 || Strategy==2
                        FullImageName           = strcat(FileRoot, ImageFolderName, ImageCode(1).name);
                    elseif Strategy==3 %only load if a new detect
                        if ~DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, FrameList(j)) %in detect mode - check Frame and FrameLoop in these.....
                            FullImageName      = strcat(FileRoot, ImageFolderName, ImageCode(1).name);
                        else
                            FullImageName      = 'NA';
                        end
                    elseif Strategy==4 %only load if a it has estimated an eye, and it is a new detect
                        if ~isnan(DataFile.S_Data.EyeTested(SeqInd, FrameList(j))) %&& ~DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, FrameLoop) %eye estimate there and new detect
                            FullImageName       = strcat(FileRoot, ImageFolderName, ImageCode.name);
                        else
                            FullImageName      = 'NA';
                        end
                    end
                    %% 
                    if ~strcmp(FullImageName, 'NA')
                        Im                      = imread(FullImageName);
                        [Result]                = CompareDataToImGUINZ(DataFile, Im, ImageCode.name,Inter(i), Trial(i), SeqInd, FrameList(j), PossErrorTypes,OptNames);
                        SimpleCode              = sprintf('Obs%s_VD%03dcm_I%i_T%02d_F%04d', Obs{i}, VD(i)*100, Inter(i), Trial(i), FrameList(j));
                        [Summary, FrameCounter] = MakeGUINZSummary(Summary,Result, SimpleCode, DorENum, FrameCounter);
                    end
                end
            end
        end
    end
    %%
    if ~isempty(MissingImageFiles) || ~isempty(MissingDataFiles)
        fileIDlog          = fopen(FileNameLog,'w'); %initialise log file
        fprintf(fileIDlog, 'MissingDataFiles: %s \nMissingImageFiles: %s', [MissingDataFiles,  MissingImageFiles]');
        fclose(fileIDlog);
    end
    if exist('Summary','var')
        fileID              = fopen(FileName,'w');
        formatSpec          = '%s %i %i \n';
        [nrows,ncols] = size(Summary);
        for row = 1:nrows
            fprintf(fileID,formatSpec,Summary{row,:});
        end
        fclose(fileID);
    end
    

    %% Plot!
    if LookAtFiles
        if ~isnan(SumD(1,1))
            XLabels                = sprintf('Outcome of "%s" analysis strategy ', StrategyList{Strategy});
            YLabels                = sprintf('Proportion of frames in each category (out of %i)', length(SumD));
            Title                  = sprintf('%s, Subset: %s',DistanceOrEye{DorENum}, StrategyList{Strategy});
            for i=1:length(PossErrorTypes)
                AllResults(i)      = [sum(SumD(:,Position)==i)]; %sum(SumD(:,Position)==2), sum(SumD(:,Position)==3), sum(SumD(:,Position)==4), sum(SumD(:,Position)==5), sum(SumD(:,Position)==6), sum(SumD(:,Position)==7)];
            end
            TotalFramesOverTime         = sum(AllResults);
            if TotalFramesOverTime>=1
                Proportion                  = AllResults/TotalFramesOverTime;
                labelledBar(PossErrorTypes, Proportion, XLabels, YLabels, Title)
            else
                fprintf('no data files yet\n')
            end
        else
            fprintf('no data files yet\n')
        end
    end
    %%
end %skip all if done



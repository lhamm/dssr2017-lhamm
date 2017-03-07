%% This script is designed to look at saved images containing bullseyes as well as data files containing information about these images
% l.hamm@auckland.ac.nz and kmis...@aucklanduni.ac.nz
% specific to confidential data, tricky to know how it might be useful to others, or if others could collaborate

% Tidy up
clearvars
close all
format long g
rng('shuffle')

%% Initialise Variables
% Variables we may want to change
AnalysisVersion         = 3.0;  % 2.1=eye analysis added in; 1.3 = change how eyes were stored and fixed tracking/detecting numbers
TestingVersion          = 1.0;  % update as we use new data files
LookAtFiles             = 1;    % if 1 will show a summary so far
ScalingR                = 7.7;  % this is based on Tonga data - could change based on adult experience
ScalingV                = 14;   % we can figure this out based on Tonga and adult experiment - update for VA analysis!
CodeImagesAsYouGo       = 1;    % we want to actively code images - will switch off if looking at bulls eye capture rate (strategy 6)
CorrectPositionStore    = cell(8000, 4);
ScoreErrors             = 0;    % do not score errors, prioritise finding correct location.
%% Ask user for input
% Who is the researcher?
ReasearchAssistants     = {'KM', 'LH'};
RANum                   = centmenu('Who are you?', ReasearchAssistants);
RA                      = ReasearchAssistants{RANum};
% What strategy do we want to use?
StrategyList            = {'SpecificSample', 'RandGenSample', 'AllNewDetects','OnlyWhenEyeDetected','All Data - just look at VA results', 'All Data - just look at bulleye capture rates', 'CodingCorrect'};
Strategy                = centmenu('What strategy do you want to take?', StrategyList);
% If we need it, ask which test we're doing, and how many trials do you want to code?
if Strategy<5
    NumberOfTrials      = GetNumberOfTrials(Strategy);
    DistanceOrEye       = {'BullsEye', 'WhichEye'};
    DorENum             = centmenu('What are tyou looking at?',DistanceOrEye); %1=BullsEye, 2=Eye
    DorE                = DistanceOrEye{DorENum};
    if DorENum==1;
        PossErrorTypes  = {'Perfect, looks sensible', 'BullsEye out of frame', 'Child obscuring bullsEye', 'BullsEye, but no rect', 'Wrong Position', 'Position OK, no width', 'Width est, wrong position'};
        Position=5;
    elseif DorENum==2;
        PossErrorTypes  = {'Perfect, CorPatch, CorID', 'BullsEye out of frame','Child obscuring bullsEye', 'CorPatch, WrongID', 'WrongPatch, CorID','WrongPatch, WrongID','No Eye RectWrong', 'No Eye RectCorrect','Eye est, wrong position'};
        Position=6;
    end
else
    Position=NaN;
end
    
% Initialise all the counters, folders, etc - no changes should need to be make, just check for accuracy
InitialiseVariables % This is a script not a function, an alternative would be to put all variables into a structure

%% Look at existing files and choose new ones to code based on input so far
[SumD, SumDUnique]          = WhatIsDoneAlready(Strategy, StrategyList, Position,1);
if Strategy<5 % less than 5 means we are not doing all the files, we want a subset
    if isnan(SumD(1,1))
        NewCombinationList      = AllCombinations; %nothing yet, start with all options
    else
        NewCombinationList      = WhatIsLeftToDo(AllCombinations,SumDUnique); % LISATODO - deal with case - you're done!
    end
elseif Strategy>=5 % This is the case where we are analysing data without coding any of it on the way - we want all combinations
    NewCombinationList         = AllCombinations;
    NumberOfTrials             = size(AllCombinations,1); % need to specify after we know how many files trials there are.
    VAResults                  = NaN((size(NewCombinationList,1)/64), 6,3);
    CodeImagesAsYouGo          = 0; %turn off coding images, just let program do it's thing.
end
if isempty(NewCombinationList)
    Done=1;
else
    [Obs, VD, Inter, Trial]     = ChooseFramesToTest(NewCombinationList, Strategy, NumberOfTrials);
    ObsList=ones(1,64);
    for i=1:length(unique((Obs)))-1
        ObsList = horzcat(ObsList, i+ones(1,64));
    end %LISATODO: currently this only works for the first half of the participants - think of better ways to store this!
end

%% Let's go through all the files - this is where we link data to images
if ~Done
    for i=1:NumberOfTrials
        i
        ImageFolderName                             = sprintf('%s%c',Obs{i},filesep);
        DataCode                                    = sprintf('%sDataFiles%c%sVD%0.1f_*.mat ',FileRoot, filesep, Obs{i},VD(i));
        flist                                       = dir(DataCode);
        NewImCnt                                    = 0;
        if isempty(flist) % Record missing data files
            MissDataCnt                             = MissDataCnt+1;
            MissingDataFiles{MissDataCnt, 1}        = DataCode;
        else
            DataFile                                = open(strcat(sprintf('%sDataFiles%c',FileRoot, filesep),(flist(1).name)));
            if Strategy==5 && mod(i, 64)==0 % 64 Trials is one full data set - now we have a data set and are in the correct indexing position
                cntVA= cntVA+1;
                VAResults(cntVA, 1:6,:)             = GetVAFromPal(DataFile, ScalingR, ScalingV);
            end
            if Strategy<5 || Strategy==6 % This is used when we want want user input on each image
                if VD(i)*100==40
                    Resolution=640; %check
                elseif VD(i)*100==150
                     Resolution=1920; %check
                end
                SeqTrialInd                         = find(TrialSeq==Trial(i));
                SeqInd                              = SeqTrialInd(Inter(i));
                MaxFrameNumberPerTrial(i)           = find(diff(~isnan(DataFile.S_Data.FrameTimingRecord(SeqInd,:)))==(-1)); %or sum(~isnan(DataFile.S_Data.FrameTimingRecord(InterLoop*TrialLoop,:)));
                Remainder                           = mod(MaxFrameNumberPerTrial(i)/2,6);
                FrameList                           = [6, MaxFrameNumberPerTrial(i)/2-Remainder];
                for j=1:length(FrameList)
                    SimpleCode                      = sprintf('Obs%s_VD%03dcm_I%i_T%02d_F%04d', Obs{i}, VD(i)*100, Inter(i), Trial(i), FrameList(j));
                    ImageCode                       = dir(strcat(FileRoot, ImageFolderName,sprintf('%s_%0.1f_%i_%i_%i_*.jpg', Obs{i}, VD(i), Inter(i), Trial(i)-1, FrameList(j))));
                    if isempty(ImageCode) % Record missing image files
                        MissImageCnt                        = MissImageCnt+1;
                        MissingImageFiles{MissImageCnt,:}   = SimpleCode;
                    else
                        FullImageName               = GetImageFileName(FileRoot, ImageFolderName, ImageCode(1).name, Strategy, DataFile, SeqInd, FrameList(j));
                        if ~strcmp(FullImageName, 'NA')
                            NewImCnt=NewImCnt+1;
                            Im                      = imread(FullImageName);
                            [Outer1, Inner1, WorkingDistance, Eye]  = NewImageAnalysis(Im, VD(i)*100, FOV);
                            NewSucessfulVD(1,NewImCnt) = calcWD(max([Outer1(3), Outer1(4)]), 3.4, Resolution,FOV);
                            if Strategy<5
                                [Result, CorrectPosition]   = CompareDataToImGUINZ(DataFile, Im, Inter(i), Trial(i), SeqInd, FrameList(j), PossErrorTypes, ScoreErrors, OptNames, Outer1, Inner1, WorkingDistance, Eye, FOV);
                                [Summary, FrameCounter]     = MakeGUINZSummary(Summary,Result, SimpleCode, DorENum, FrameCounter);
                            end
                        end
                    end
                    CorrectPositionStore{i,j} = CorrectPosition;
                    CorrectPositionStore{i,4} = SimpleCode;
                end
                WidthSummary(ObsList(i), TrialCnt(i),1)     = (sum(~isnan(DataFile.S_Data.FrameBullsEyeWidthRecord(SeqInd, 1:MaxFrameNumberPerTrial(i)))))/(sum(isnan(DataFile.S_Data.FrameBullsEyeWidthRecord(SeqInd, 1:MaxFrameNumberPerTrial(i)))+(sum(~isnan(DataFile.S_Data.FrameBullsEyeWidthRecord(SeqInd, 1:MaxFrameNumberPerTrial(i))))))); % proportion of frames on one trial, in which a bulls eye estimate was available
                if ~isnan(WidthSummary(ObsList(i), TrialCnt(i),1))
                    WidthSummary(ObsList(i), TrialCnt(i),2)     = min(DataFile.S_Data.FrameEstimatedDistanceRecord(SeqInd, 1:MaxFrameNumberPerTrial(i)));
                end
                NewWidthSummary(ObsList(i),TrialCnt(i),2)   =  sum(~isnan(NewSucessfulVD(1,:)))/(sum(isnan(NewSucessfulVD(1,:)))+sum(~isnan(NewSucessfulVD(1,:))));%proportion correct from new analysis (1/6th of the data goes into the proportion)
                if ~isnan(NewWidthSummary(ObsList(i),TrialCnt(i),2))
                    NewWidthSummary(ObsList(i),TrialCnt(i),2)   =  min(NewSucessfulVD(1,:));%proportion correct from new analysis (1/6th of the data goes into the proportion)
                end
                

            end
        end
    end
    %% Finished with gathering information, now let's save results
    %LISATODO: missing data and image files are limited in number of lines, update this!
    if Strategy<5
        if ~isempty(MissingImageFiles{1,1})
            fileIDlog          = fopen(FileNameILog,'w'); %initialise log file
            fprintf(fileIDlog, '%s\n%s\n%s\n%s\n%s\n%s', MissingImageFiles{1,:},  MissingImageFiles{2,:}, MissingImageFiles{3,:}, MissingImageFiles{4,:},  MissingImageFiles{5,:}, MissingImageFiles{6,:});
            fclose(fileIDlog);
        end
        if ~isempty(MissingDataFiles{1,1})
            fileIDlog          = fopen(FileNameDLog,'w'); %initialise log file
            fprintf(fileIDlog,'%s\n%s\n%s',MissingDataFiles{1,:}, MissingDataFiles{2,:}, MissingDataFiles{4,:});
            fclose(fileIDlog);
        end
        if exist('Summary','var') % will not be the case for Strategy 5
            fileID              = fopen(FileName,'w');
            formatSpec          = '%s %i %i \n';
            [nrows,ncols] = size(Summary);
            for row = 1:nrows
                fprintf(fileID,formatSpec,Summary{row,:});
            end
            fclose(fileID);
        end
    elseif Strategy==5
        UniqueMissingDataFiles = unique(MissingDataFiles);
        save(FileNameStrat5, 'VAResults','UniqueMissingDataFiles') % These are matlab files - not very future-proof
    elseif Strategy==6
        UniqueMissingDataFiles = unique(MissingDataFiles);
        save(FileNameStrat6, 'WidthSummary','NewWidthSummary','UniqueMissingDataFiles') % These are matlab files - not very future-proof
    end
    
    %% Now let's have a look at the results so far
    if LookAtFiles
        if Strategy<5 && ~isnan(SumD(1,1))
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
        elseif Strategy==5
            SummaryImages(VAResults);
        elseif Strategy==6
            DistanceImages(NewWidthSummary, WidthSummary, Obs, VD, SumDUnique);
        end
    end
end %skip all if done



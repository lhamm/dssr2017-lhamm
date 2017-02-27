%% This script is designed to look at saved images containing bullseyes as well as data files containing information about these images
%intro (name of program, name of authors, descriptions)
clearvars
close all
format long g
rng('shuffle')

%% initialise variables
%ones we need to change
AnalysisVersion     = 2.1; %2.1=eye analysis added in; 1.3 = change how eyes were stored and fixed tracking/detecting numbers
TestingVersion      = 1.0; % update as we use new data files
LookAtFiles         = 1; %if 1 will show a summary so far
ScalingR            = 7.7;
ScalingV            = 14;

%Ask user for input
ReasearchAssistants = {'KM', 'LH'};
RANum               = centmenu('Who are you?', ReasearchAssistants);
RA                  = ReasearchAssistants{RANum};

StrategyList        = {'SpecificSample', 'RandGenSample', 'AllNewDetects','OnlyWhenEyeDetected','All Data - just look at VA results'};
Strategy            = centmenu('What strategy do you want to take?', StrategyList);
if Strategy==2
    NumberOfTrials  = centmenu('How many trials do you want to code?', {'1','2','3','4','5'});
elseif Strategy==1
    NumberOfTrials  = 1;
elseif Strategy==3 || Strategy ==4
    Options         = {'10','20','50','100','500'};
    Input           = centmenu('How many trials do you want to code?', Options);
    NumberOfTrials  = str2double(Options(Input));
end

if Strategy<5
    DistanceOrEye       = {'BullsEye', 'WhichEye'};
    DorENum             = centmenu('What are tyou looking at?',DistanceOrEye); %1=BullsEye, 2=Eye
    DorE                = DistanceOrEye{DorENum};
    
    if DorENum==1;
        PossErrorTypes  = {'Perfect, looks sensible', 'BullsEye out of frame', 'Child obscuring bullsEye', 'BullsEye, but no rect', 'Wrong Position', 'Position OK, no width', 'Width est, wrong position'};
        Position=5;
    else
        PossErrorTypes  = {'Perfect, CorPatch, CorID', 'BullsEye out of frame','Child obscuring bullsEye', 'CorPatch, WrongID', 'WrongPatch, CorID','WrongPatch, WrongID','No Eye RectWrong', 'No Eye RectCorrect','Eye est, wrong position'};
        Position=6;
    end
end

% initialise variables - could make a structure containing these fields
FileRoot                    = GetPathSpecificToUser('Documents','GUINZData');
[Obs, VD, Eyes, Stim]       = GetDataTypeListsGUINZ(FileRoot);
AllCombinations             = allcomb(str2double(Obs), VD*100, 1:4, 1:16);
MaxFrames                   = GetMaxFrames(FileRoot, Obs, '.jpg');

OptNames                    = {'Flower', 'Car', 'Butterfly','Rocket','Duck','Heart','House','Moon','Tree','Rabbit'};
InterSeq                    = horzcat(ones(1,16), repmat(2,1,16), repmat(3,1,16), repmat(4,1,16));
TrialSeq                    = repmat(1:16,1,4);
MissingDataFiles            = cell(10,1);
MissingImageFiles           = cell(10,1);
MissDataCnt                 = 0;
MissImageCnt                = 0;
cntVA                       = 0;
Done                        = 0;
FrameCounter                = 0;
Summary                     = cell(1,3);

%% Look at existing files and choose new ones
if Strategy<5 % we are not doing all the files.
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
    
    FileName             = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s.dat', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA);
    FileNameILog         = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s_%s.txt', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA, 'IMAGE');
    FileNameDLog         = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s_%s.txt', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA,'DATA');
   
elseif Strategy==5 %check this
     NewCombinationList      = AllCombinations;
     NumberOfTrials          = size(AllCombinations,1); % need to specify after we know how many files trials there are.
     [Obs, VD, Inter, Trial] = ChooseFramesToTest(NewCombinationList, Strategy, NumberOfTrials);
     VAResults               = NaN((size(NewCombinationList,1)/64), 6,3);
     FileNameStrat5      = sprintf('VAAnalysis_%i_%s_RA_%s.mat', Strategy, MyDate, RA); 
end
%% set up log file for test run
if ~Done

 
    % LISATODO: currently displays in the location you ran it from - try to
    % move but might be ok to leave - easy to move if correct.
    
    %try
    %% start loop
    for i=1:NumberOfTrials
        ImageFolderName                         = sprintf('%s%c',Obs{i},filesep);
        DataCode                                = sprintf('%sDataFiles%c%sVD%0.1f_*.mat ',FileRoot, filesep, Obs{i},VD(i));
        flist                                   = dir(DataCode);
        if isempty(flist)
            MissDataCnt=MissDataCnt+1;
            MissingDataFiles{MissDataCnt, 1}    = DataCode;
        else
            DataFile                            = open(strcat(sprintf('%sDataFiles%c',FileRoot, filesep),(flist(1).name)));
            if Strategy==5 && mod(i, 64)==0 %only do this when all the files are present
                cntVA= cntVA+1;
                VAResults(cntVA, 1:6,:)         = GetVAFromPal(DataFile, ScalingR, ScalingV);
            end
            if Strategy<5 % if strategy ==5, it is doing something without user input in this phase - update this for use with new input
                SeqTrialInd                         = find(TrialSeq==Trial(i));
                SeqInd                              = SeqTrialInd(Inter(i));
                MaxFrameNumberPerTrial              = find(diff(~isnan(DataFile.S_Data.FrameTimingRecord(SeqInd,:)))==(-1)); %or sum(~isnan(DataFile.S_Data.FrameTimingRecord(InterLoop*TrialLoop,:)));
                FrameList                           = 6:6:MaxFrameNumberPerTrial;
                for j=1:length(FrameList)
                    SimpleCode                      = sprintf('Obs%s_VD%03dcm_I%i_T%02d_F%04d', Obs{i}, VD(i)*100, Inter(i), Trial(i), FrameList(j));
                    ImageCode                       = dir(strcat(FileRoot, ImageFolderName,sprintf('%s_%0.1f_%i_%i_%i_*.jpg', Obs{i}, VD(i), Inter(i), Trial(i)-1, FrameList(j))));
                    if isempty(ImageCode)
                        MissImageCnt=MissImageCnt+1;
                        MissingImageFiles{MissImageCnt,:} = SimpleCode;
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
                                FullImageName       = strcat(FileRoot, ImageFolderName, ImageCode(1).name);
                            else
                                FullImageName      = 'NA';
                            end
                        end
                        %%
                        if ~strcmp(FullImageName, 'NA')
                            Im                      = imread(FullImageName);
                            [Result]                = CompareDataToImGUINZ(DataFile, Im, ImageCode(1).name,Inter(i), Trial(i), SeqInd, FrameList(j), PossErrorTypes,OptNames);
                            % SimpleCode              = sprintf('Obs%s_VD%03dcm_I%i_T%02d_F%04d', Obs{i}, VD(i)*100, Inter(i), Trial(i), FrameList(j));
                            [Summary, FrameCounter] = MakeGUINZSummary(Summary,Result, SimpleCode, DorENum, FrameCounter);
                        end
                    end
                end
            end
        end
    end
    %%
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
        save(FileNameStrat5, 'VAResults','UniqueMissingDataFiles')
    end
    
    
    %% Plot!
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
            % made a function for this
            NearInd             = find(VAResults(:,2,1)==40);
            RERegNear           = VAResults(NearInd, 3, 1:2); BadRERegNear= find(RERegNear>0.2);
            REVanNear           = VAResults(NearInd, 4, 1:2); BadREVanNear= find(REVanNear>0.2);
            LERegNear           = VAResults(NearInd, 5, 1:2); BadLERegNear= find(LERegNear>0.2);
            LEVanNear           = VAResults(NearInd, 6, 1:2); BadLEVanNear= find(LEVanNear>0.2);
            NearCodes           = VAResults(NearInd, 1, 1:2); 
            PluggedInNear       = VAResults(NearInd, 4, 3); %only for RE vanishing
           
            
            [CorR_LENear, CorP_LENear, BA_LENear] = LisaBlandAltman(LERegNear, LEVanNear, 'LERegNear', 'LEVanNear', NearCodes, PluggedInNear);
            [CorR_RENear, CorP_RENear, BA_RENear] = LisaBlandAltman(RERegNear, REVanNear, 'RERegNear', 'REVanNear', NearCodes, PluggedInNear);
            
            DistInd             = find(VAResults(:,2,1)==150);
            RERegDist           = VAResults(DistInd, 3, 1:2);
            REVanDist           = VAResults(DistInd, 4, 1:2);
            LERegDist           = VAResults(DistInd, 5, 1:2);
            LEVanDist           = VAResults(DistInd, 6, 1:2);
            DistCodes           = VAResults(DistInd, 1, 1:2); 
            PluggedInDist       = VAResults(DistInd, 4, 3); %only for RE vanishing
            
            [CorR_LEDist, CorP_LEDist, BA_LEDist] = LisaBlandAltman(LERegDist, LEVanDist, 'LERegDist', 'LEVanDist', DistCodes, PluggedInDist);
            [CorR_REDist, CorP_REDist, BA_REDist] = LisaBlandAltman(RERegDist, REVanDist, 'RERegDist', 'REVanDist', DistCodes, PluggedInDist);
            
        else
            fprintf('no data files yet\n')
            
        end
    end
    %%
end %skip all if done



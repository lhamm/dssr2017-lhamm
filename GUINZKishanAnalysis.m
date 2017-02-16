% intro (name of program, name of authors, descriptions)
clearvars
close all



%% initialise variables

RunDemo         = 0; %if 1, just a test, if 0, run all through
RandGenSample   = 1;

PossErrorTypes  = {'No Bullseye', 'BullsEye No Rect', 'BullsEye Wrong Rect', 'BullsEye No Width', 'Child Covering BullsEye'};
OptNames        = {'Flower', 'Car', 'Butterfly','Rocket','Duck','Heart','House','Moon','Tree','Rabbit'};

[FileRoot]                  = GetDataGUINZ;
[Obs, VD, Eyes, Stim]       = GetDataTypeListsGUINZ(FileRoot);
Inter                       = 1: (length(Eyes)+length(Stim));
Trial                       = 1:16;

MissingDataFiles='';
MissingImageFiles='';
InterSeq=horzcat(repmat(1,1,16), repmat(2,1,16), repmat(3,1,16), repmat(4,1,16)); 
TrialSeq=repmat([1:16],1,4);

%% Pick List to test
if RunDemo
    Obs     = Obs(12:13); %chose a number
    VD      = VD(1); %chose a number
    Eyes    = Eyes{1}; %chose a number
    Stim    = Stim{1}; %chose a number
    Inter   = 1; %chose a number....this is related to last 2...
end

if RandGenSample
    rng('shuffle')
    ObsList     = randi(length(Obs),1); %need this for indexing
    Obs         = (Obs(ObsList));
    Inter       = randi(4,1);  %need this for indexing
    Trial       = randi(16,1); 

    % use both VDs
end

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
                    if RandGenSample
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
                                    % TODO: if this is empty, need to look into it
                                    FullImageName   = strcat(FileRoot, ImageFolderName, ImageCode.name);
                                    Im              = imread(FullImageName);
                                    %ImStore(
                                    
                                    % if isnan(DataFile.S_Data.FrameBullsEyeWidthRecord(InterLoop*TrialLoop, FrameLoop))
                                    %%
                                    
                                    [Type, Exit, NewError]       = CompareDataToImGUINZ(DataFile, Im, ImageCode.name,Inter(InterLoop), Trial(TrialLoop), SeqInd, FrameLoop, PossErrorTypes,OptNames);
                                    if ~strcmp(NewError, 'Na')
                                       PossErrorTypes={PossErrorTypes{1:end},NewError};
                                    end
                                    close all
                                    
                                    % TODO: make log file
                                    % TODO: make .csv file
                                end %end of the if missing image part
                            end
                        end
                    end
                end
            end %end of if missing data
        end
    end



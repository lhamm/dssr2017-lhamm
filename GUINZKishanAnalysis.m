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
FrameCounter=0;
 
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

%% set up log file for test run
ReasearchAssistants = {'KM', 'LH'};
RANum               = centmenu('Who are you?', ReasearchAssistants);
RA                  = ReasearchAssistants{RANum};
FileName            = strcat(sprintf('%sAnalysisData%c',FileRoot,filesep),sprintf('DataAnalysis_%s_%s', MyDate, RA));
%AnalysisSession     = 1; %make dynamic
FileName            = sprintf('DataAnalysis_%s_%s', MyDate, RA);

fileID              = fopen(FileName,'w');
formatSpec          = '%s %i %i \n';


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
                                    FullImageName   = strcat(FileRoot, ImageFolderName, ImageCode.name);
                                    Im              = imread(FullImageName);                                   
                                    [BEResult, NewError]       = CompareDataToImGUINZ(DataFile, Im, ImageCode.name,Inter(InterLoop), Trial(TrialLoop), SeqInd, FrameLoop, PossErrorTypes,OptNames);
                                    if ~strcmp(NewError, 'Na')
                                       PossErrorTypes={PossErrorTypes{1:end},NewError};
                                    end
                                    FrameCounter=FrameCounter+1;
                                    close all
                                    % do eye analysis
                                    SimpleCode=sprintf('Obs%s_VD%icm_I%i_T%i_F%i', Obs{ObsLoop}, VD(VDLoop)*100, Inter(InterLoop), Trial(TrialLoop), FrameLoop);
                                    EyeResult=NaN;
                                    
                                    %% work on
                                    Summary{FrameCounter,1}=SimpleCode;
                                    Summary{FrameCounter,2}=BEResult;
                                    Summary{FrameCounter,3}=NaN;

                                    % TODO: make .csv file
                                end %end of the if missing image part
                            end
                        end
                    end
                end
            end %end of if missing data
        end
    end
    
%T=table(Code, BullsEye_Res, EyeID_Res);

[nrows,ncols] = size(Summary);
for row = 1:nrows
    fprintf(fileID,formatSpec,Summary{row,:});
end

fclose(fileID);



%writetable(T, 'DataAnalysis.xlsx', 'Sheet', AnalysisSession) % sprintf('%s%s_%s %s.dat',WhereToSave, RA, MyDate, SimpleCode)); 
%dlmwrite(sprintf('%s%s_%s O:%s I:%i T:%i.dat',WhereToSave, RA, MyDate, Obs{ObsLoop},Inter(InterLoop), Trial(TrialLoop)),Summary)
                                    




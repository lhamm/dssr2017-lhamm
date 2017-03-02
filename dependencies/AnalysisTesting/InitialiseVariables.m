% InitialiseVariables

% initialise variables - could make a structure containing these fields
FileRoot                    = GetPathSpecificToUser('Documents','GUINZData');
if Strategy<5
    FileName                    = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s.dat', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA);
    FileNameILog                = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s_%s.txt', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA, 'IMAGE');
    FileNameDLog                = sprintf('DataAnalysis_%i_%i_AVer%0.1f_TVer%0.1f_Date_%s_RA_%s_%s.txt', Strategy, DorENum, AnalysisVersion, TestingVersion, MyDate, RA,'DATA');
elseif Strategy==5
    FileNameStrat5          = sprintf('VAAnalysis_%i_%s_RA_%s.mat', Strategy, MyDate, RA);
elseif Strategy==6
    FileNameStrat5          = sprintf('BullsEyeSuccessSummary_%i_%s_RA_%s.mat', Strategy, MyDate, RA);
end
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
NewImCnt                    = 0;
NewSucessfulWidth           = NaN(1);
Done                        = 0;
FrameCounter                = 0;
Summary                     = cell(1,3);
FOV                         = 76; %check this!

WidthSummary               = NaN(length(unique(Obs))*2, 64);
NewWidthSummary            = NaN(length(unique(Obs))*2, 64);

  
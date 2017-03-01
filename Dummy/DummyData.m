%% test data intialize
format long g

%% GetPathSpecificToUser
%check to see if function is able to find require folder
%seems as if titles are case insensitive as "Dssr2017-lhamm" is incorrectly
%named with a capital at the start

DestinationAfterUser1 = 'Desktop';
DestinationAfterUser2 = 'Dssr2017-lhamm';
DestinationAfterUser3 = 'Dummy';
DestinationAfterUser4 = 'Should not exist';

FileRoot = GetPathSpecificToUser(DestinationAfterUser1, DestinationAfterUser2, DestinationAfterUser3);
res = FileRoot;

assert(strcmp (GetPathSpecificToUser('Desktop', 'Dssr2017-lhamm', 'Dummy'),'C:\Users\Dakin Lab\Desktop\Dssr2017-lhamm\Dummy\') ==1,'The strings should be the same') 
%% GetDataTypeListsGUINZ
%under Dummy folder, there are 10 folders however only 9 of them are
%correctly named so only 9 folders should be identified

Location = FileRoot; %for the sake of running the program without crashing

res1    = (FileRoot);
res2    = [0.4 1.5]; %viewing distances used 
res3    = {'RE','LE'}; % could define differently
res4    = {'Reg','Van'}; %could define differently

[Obs, VD, Eyes, Stim] = GetDataTypeListsGUINZ(Location);
assert(length(GetDataTypeListsGUINZ('C:\Users\Dakin Lab\Desktop\Dssr2017-lhamm\Dummy\')) == 9, 'The total length should be equal to 9')
%% GetMaxFrames
% 23 Frames PX 1-8 where There are 8 Int1, 6Int2, 5Int3 and 4Int4 and 4
% 1.5WD all of Int1 all of same date and time acquired (excl 10005.3)
% Px9 has 24 Frames, Px10 (incorrect name) has 25 frames.  Thus max frames
% should equal 24

MaxFrames                   = GetMaxFrames(FileRoot, Obs, '.jpg');

%strfind[FileRoot,DestinationAfterUser1] >=10
assert((MaxFrames) == 24,'Your MaxFrames value should equal 24')
%assert(GetMaxFrames('C:\Users\Dakin Lab\Desktop\Dssr2017-lhamm\Dummy\',...
   % {'10001.4','10002.6','10003.3','10004.2','10005.3','10006.8','10007.3','10008.8','10009.5'},'.jpg') == 24, ...
    %'Your MaxFrames value should equal 24')


%% WhatIsLeftToDo
% DummySumDUnique Opt1 should no longer be on NewCombinationList, Opt2 have WD written differently and should be on list
% 040 and 40 classified as same so Opt3 not on list either

DummyAllCombinations    = [10003.4, 40, 1, 1;10003.4, 40, 1, 2; 10003.4, 40, 1, 3];
DummySumDUnique         = [10003.4, 40, 1, 1, NaN, 2; 10003.4, 0.4, 1, 2, NaN, 2;10003.4, 040, 1, 3, NaN, 1];

NewCombinationList      = WhatIsLeftToDo(DummyAllCombinations,DummySumDUnique);
%assert(sum(size(WhatIsLeftToDo([10003.4,40,1,1;10003.4,40,1,2;10003.4,40,1,3],...
    %[10003.4,40,1,1,NaN,2;10003.4,0.4,1,2,NaN,2;10003.4,40,1,3,NaN,1]))) == ...
    %5, 'There should only be one unique trial')

%% WhatIsDoneAlready
% Use the folowing format for below: Strat Number, SumD, SumDUnique)
%Strat 1, 8x6 values, 1x6 values (same trial multiple frames)
%Strat 2, 16x6 values, 3x6 values (2 trials with 1 trial having 2 responses)
%Strat 3, 8x6 values, 6x6 values (6 trials where 1 trial has 3 frames
%whereas others have 1 frame)
%Strat 4, NaN, NaN (as no info in folder)

Strategy            = 2; %ceil(4*rand(1,1)); %random choose 1 of the below strats
StrategyList        = {'DummySpecificSample', 'DummyRandGenSample', 'DummyAllNewDetects','DummyOnlyWhenEyeDetected'};
Position            = 5; %BullsEye
Legitimacy          = 2; % using data from the dummy data file

[SumD, SumDUnique] = WhatIsDoneAlready(Strategy, StrategyList, Position, Legitimacy);

%assert(nansum(sum(WhatIsDoneAlready(2,{'DummySpecificSample', 'DummyRandGenSample',...
 %   'DummyAllNewDetects','DummyOnlyWhenEyeDetected'},5,2)))==162619.8, ...
  %  'Dummy Folder Value Total is 162619.8 if you add all the columns together and ignore the NaNs')

%% ChooseFramesToTest = visible results so no test written
%% centmenu = in built tests and PT will rip me to shreds if I test it
%% CompareDataToImGUINZ = visible picture given so no test written
%% MakeGUINZSummary
% Result of test should have NaN in column 2 if DummyDorENum is 1, NaN in
% column 2 if DummyDorENum is 2

DummySummary                 = cell(1,3);
DummyFrameCounter            = 0;

DummySimpleCode              = 10001.4; %removed other details as irrelevant in test
DummyResult                  = 10; % wanted to have some fun here
DummyDorENum                 = 1; %ceil(2*rand(1,1));

[DummySummary, DummyFrameCounter] = MakeGUINZSummary(DummySummary, DummyResult, DummySimpleCode, DummyDorENum, DummyFrameCounter);
%% labelledBar = visible results in form of bar graph so no written test bothered

%% GetNumberOfTrials = user interface - the only test we can use is for strategy 1 - in which we specify 1 trial
assert(GetNumberOfTrials(1)==1, 'We have set strategy 1 to have 1 trial only');

%% Next step is to create actual test functions using the assert command
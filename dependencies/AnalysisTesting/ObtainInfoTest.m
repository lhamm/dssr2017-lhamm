% Test GetPathSpecificToUser
function tests   = ObtainInfoTest
tests            = functiontests(localfunctions);
end

function setupOnce(testCase)
testCase.TestData.origPath=pwd;
testCase.TestData.tmpFolder = ['tmpFolder' datestr(now, 30)];
mkdir(testCase.TestData.tmpFolder)
cd(testCase.TestData.tmpFolder)

UserName                    = getenv('username');
testCase.TestData.UserName  = UserName;
testCase.TestData.FileRoot  = sprintf('C:%cUsers%c%s%cDesktop%cdssr2017-lhamm%cDummy%c',filesep, filesep, UserName, filesep, filesep, filesep, filesep);
testCase.TestData.Obs       = {'10001.4','10002.6','10003.3','10004.2','10005.3','10006.8','10007.3','10008.8','10009.5'};
end 

function teardownOnce(testCase)
cd(testCase.TestData.origPath)
rmdir(testCase.TestData.tmpFolder)
end

function test_GetPathSpecificToUser(testCase)
DestinationAfterUser1 = 'Desktop';
DestinationAfterUser2 = 'dssr2017';
DestinationAfterUser3 = 'Dummy';
%UserName              = testCase.TestData.UserName;
FileRoot=sprintf('C:%cUsers%c%s%c%s%c%s%c%s%c',filesep, filesep, testCase.TestData.UserName, filesep, DestinationAfterUser1, filesep, DestinationAfterUser2, filesep, DestinationAfterUser3, filesep);
testCase.TestData.FileRoot = FileRoot;
assert(strcmp(GetPathSpecificToUser(DestinationAfterUser1,DestinationAfterUser2, DestinationAfterUser3),FileRoot),'Set up to be this file path')
end

function test_GetDataTypeListsGUINZ(testCase)
Location=testCase.TestData.FileRoot;
testCase.TestData.Obs = GetDataTypeListsGUINZ(Location);
assert(length(GetDataTypeListsGUINZ(Location))==9, 'There are 9 participants in this folder')
end

function test_GetMaxFrames(testCase)
Obs         = testCase.TestData.Obs;
FileRoot    = testCase.TestData.FileRoot; 
assert(GetMaxFrames(FileRoot, Obs, '.jpg')==24, '24 is the larget number of images in the dummy folders')
end





   


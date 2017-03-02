% Test GetPathSpecificToUser

function setupOnce(testCase)
testCase.TestData.origPath=pwd;
testCase.TestData.tmpFolder = ['tmpFolder' datestr(now, 30)];
    mkdir(testCase.TestData.tmpFolder)
    cd(testCase.TestData.tmpFolder)
    
    % What do we need here
  
testCase.TestData.DestinationAfterUser1 = 'Desktop';
testCase.TestData.DestinationAfterUser2 = 'Dssr2017-lhamm';
testCase.TestData.DestinationAfterUser3 = 'Dummy';
testCase.TestData.DestinationAfterUser4 = 'Should not exist';
testCase.TestData.UserName=getenv('username');
DestinationAfterUser1 = 'Desktop';
DestinationAfterUser2 = 'Dssr2017-lhamm';
DestinationAfterUser3 = 'Dummy';
UserName = getenv('username');
testCase.TestData.FileRoot=sprintf('C:%cUsers%c%s%c%s%c%s%c%s%c',filesep, filesep, UserName, filesep, DestinationAfterUser1, filesep, DestinationAfterUser2, filesep, DestinationAfterUser3, filesep);

%assert(strcmp(GetPathSpecificToUser(DestinationAfterUser1,DestinationAfterUser2, DestinationAfterUser3),FileRoot),'Set up to be this file path')
end 

function teardownOnce(testCase)
cd(testCase.TestData.origPath)
rmdir(testCase.TestData.tmpFolder)
end

function test_GetPathSpecificToUser(testCase)
DestinationAfterUser1 = testCase.TestData.DestinationAfterUser1;
DestinationAfterUser2 = testCase.TestData.DestinationAfterUser2;
DestinationAfterUser3 = testCase.TestData.DestinationAfterUser3;
UserName              = testCase.TestData.UserName
testCase.TestData.FileRoot=sprintf('C:%cUsers%c%s%c%s%c%s%c%s%c',filesep, filesep, UserName, filesep, DestinationAfterUser1, filesep, DestinationAfterUser2, filesep, DestinationAfterUser3, filesep);

%DestinationAfterUser4 = testCase.TestData.DestinationAfterUser4;
assert(strcmp(GetPathSpecificToUser(DestinationAfterUser1,DestinationAfterUser2, DestinationAfterUser3),FileRoot),'Set up to be this file path')
end



   


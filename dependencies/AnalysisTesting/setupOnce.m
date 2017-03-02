% Test GetPathSpecificToUser

function setupOnce(testCase)
testCase.TestData.origPath=pwd;
testCase.TestData.tmpFolder = ['tmpFolder' datestr(now, 30)];
    mkdir(testCase.TestData.tmpFolder)
    cd(testCase.TestData.tmpFolder)
    
    % What do we need here
    
DestinationAfterUser1 = 'Desktop';
DestinationAfterUser2 = 'Dssr2017-lhamm';
DestinationAfterUser3 = 'Dummy';
DestinationAfterUser4 = 'Should not exist';
UserName=getenv('username');

FileRoot=sprintf('C:%cUsers%c%s%c%s%c%s%c%s%c',filesep, filesep, UserName, filesep, DestinationAfterUser1, filesep, DestinationAfterUser2, filesep, DestinationAfterUser3, filesep);

assert(strcmp(GetPathSpecificToUser(DestinationAfterUser1,DestinationAfterUser2, DestinationAfterUser3),FileRoot),'Set up to be this file path')
end 

function teardownOnce(testCase)
cd(testCase.TestData.origPath)
rmdir(testCase.TestData.tmpFolder)
end


   


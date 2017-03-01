%% Test for max frames in a folder
%assert((MaxFrames) == 24,'Your MaxFrames value should equal 24')

%FileRoot = GetPathSpecificToUser(DestinationAfterUser1, DestinationAfterUser2, DestinationAfterUser3);
%xxx = strfind[FileRoot,DestinationAfterUser1] >=10;
%assert(xxx == 10,'not working');

assert(GetMaxFrames('C:\Users\Dakin Lab\Desktop\Dssr2017-lhamm\Dummy\',...
    {'10001.4','10002.6','10003.3','10004.2','10005.3','10006.8','10007.3','10008.8','10009.5'},'.jpg') == 24, ...
    'Your MaxFrames value should equal 24')

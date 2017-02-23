function [res]=GetDataGUINZ(DestinationAfterUser1, DestinationAfterUser2, DestinationAfterUser3)
% User name set into predefined path where data exists
% DestimationAfterUser is a string with foldernames after user is specified
Inputs= nargin;

UserName=getenv('username');

if ~isempty(DestinationAfterUser1)
    FileRoot=sprintf('C:%cUsers%c%s%c%s%c',filesep, filesep, UserName, filesep,DestinationAfterUser1, filesep);
end

if Inputs>=2
    if ~isempty(DestinationAfterUser2)
        FileRoot=sprintf('%s%s%c',FileRoot, DestinationAfterUser2, filesep);
    end
end

if Inputs>=3
    if ~isempty(DestinationAfterUser3) && exist('DestinationAfterUser3','var')
        FileRoot=sprintf('%s%s%c',FileRoot, DestinationAfterUser3, filesep);
    end
end

res=FileRoot;
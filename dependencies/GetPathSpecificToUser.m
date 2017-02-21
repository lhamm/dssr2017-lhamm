function [res]=GetPathSpecificToUser(DestinationAfterUser1, DestinationAfterUser2, DestinationAfterUser3, DestinationAfterUser4)
% User name set into predefined path with filesep
% Each input is a folder name as  a string, starting after UserName, with a
% current max of 3 - ends with a filesep!

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

if Inputs>=4
    if ~isempty(DestinationAfterUser4) && exist('DestinationAfterUser4','var')
        FileRoot=sprintf('%s%s%c',FileRoot, DestinationAfterUser4, filesep);
    end
end



res=FileRoot;
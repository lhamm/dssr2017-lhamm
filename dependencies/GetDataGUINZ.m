function [res]=GetDataGUINZ
% User name set into predefined path where data exists
UserName=getenv('username');
FileRoot=sprintf('C:%cUsers%c%s%cDocuments%cGUINZData%c',filesep, filesep, UserName, filesep, filesep, filesep);
res=FileRoot;
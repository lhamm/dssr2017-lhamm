function [maxfiles, Longest] = GetMaxFrames(FileRoot, FolderNames, FileType)
% give root and folderlist, returns the folder name containing the most
% files of type 'FileType' (all three input arguements need to be strings)
for i=length(FolderNames)
a=dir(sprintf('%s%s%c*%s',FileRoot,FolderNames{i}, filesep, FileType));
b=length(a);
end
[maxfiles, index]    = max(b);
Longest             = FolderNames{index};

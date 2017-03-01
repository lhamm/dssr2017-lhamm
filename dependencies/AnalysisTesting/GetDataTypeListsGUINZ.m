function [res1 res2 res3 res4] = GetDataTypeListsGUINZ(Location)
% gets lists of data types from information in data folders

%get participant lists who have images
cnt=0;
FolderList  = dir(Location); %could avoid loop and defining by length if learned to use dir
for i=1:length(FolderList)
    if length(FolderList(i).name)==7
        cnt=cnt+1;
        ParticipantList{1,cnt}=FolderList(i).name;
    end
end
res1=ParticipantList;

% get 
res2    = [0.4 1.5]; %viewing distances used
res3    = {'RE','LE'}; % could define differently
res4    = {'Reg','Van'}; %could define differently

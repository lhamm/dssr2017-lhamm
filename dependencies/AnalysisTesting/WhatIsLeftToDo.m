function NewCombinationList          = WhatIsLeftToDo(AllCombinations,SumDUnique)
%% all combinations is a n by 4 matrix, SumDUnique is at least 4 wide
% if done, it returns an empty matrix
Input=nargin;
Arg1=size(AllCombinations,2);
Arg2=size(SumDUnique,2);
if Arg1>Arg2
    error('Argument 2 needs to be longer than argument 1')
end

%% needs to be tested!
%LISATODO: check what happens when this is done.
for i=1:size(SumDUnique,1)
       % ObsDone           = find(ismember(AllCombinations, SumDUnique(i,1:4)));
        ObsDone           = find(AllCombinations(:,1)==SumDUnique(i,1) & AllCombinations(:,2)==SumDUnique(i,2) & AllCombinations(:,3)==SumDUnique(i,3) & AllCombinations(:,4)==SumDUnique(i,4));   
        AllCombinations(ObsDone,:)=[];
end
NewCombinationList=AllCombinations;


% find(ismember(M,X),1)
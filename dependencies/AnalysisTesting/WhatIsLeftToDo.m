function NewCombinationList          = WhatIsLeftToDo(AllCombinations,SumDUnique)
% check what is left to do
%% needs to be tested!
%LISATODO: check what happens when this is done.

for i=1:size(SumDUnique,1)
        ObsDone           = find(AllCombinations(:,1)==SumDUnique(i,1) & AllCombinations(:,2)==SumDUnique(i,2) & AllCombinations(:,3)==SumDUnique(i,3) & AllCombinations(:,4)==SumDUnique(i,4));   
        AllCombinations(ObsDone,:)=[];
end
NewCombinationList=AllCombinations;

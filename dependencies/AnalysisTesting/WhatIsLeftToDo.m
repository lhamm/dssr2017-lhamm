function NewCombinationList          = WhatIsLeftToDo(AllCombinations,SumDUnique)
%% check what is left to do

for i=1:length(SumDUnique)
        ObsDone           = find(AllCombinations(:,1)==SumDUnique(i,1) & AllCombinations(:,2)==SumDUnique(i,2) & AllCombinations(:,3)==SumDUnique(i,3) & AllCombinations(:,4)==SumDUnique(i,4));   
        AllCombinations(ObsDone,:)=[];
end
NewCombinationList=AllCombinations;

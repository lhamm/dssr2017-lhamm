% test data

% WhatIsLeftToDo
DummyAllCombinations    = [10003.4, 40 1 1;10003.4, 40, 1 2; 10003.4, 40, 1 3];
DummySumDUnique         = [10003.4, 40, 1, 3, NaN, 2];

NewCombinationList      = WhatIsLeftToDo(DummyAllCombinations,DummySumDUnique)

%WhatIsAlreadyDone
Strategy            = 3; %new detects
StrategyList        = {'SpecificSample', 'RandGenSample', 'AllNewDetects','OnlyWhenEyeDetected'};
Position            = 5; %BullsEye

[SumD, SumDUnique] = WhatIsDoneAlready(Strategy, StrategyList, Position)




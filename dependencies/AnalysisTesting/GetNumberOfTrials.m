function [NumberOfTrials] = GetNumberOfTrials(Strategy)
%% Use the strategy input to decide how what to as user about number of trials
% Strategy is a number from 1 to 5 at this stage

if Strategy==1
    NumberOfTrials  = 1;
else
    Options         = {'10','20','50','100','500'};
    Input           = centmenu('How many trials do you want to code?', Options);
    NumberOfTrials  = str2double(Options(Input));
end
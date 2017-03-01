function [NumberOfTrials] = GetNumberOfTrials(Strategy)
%% Use the strategy input to decide how what to as user about number of trials
% Strategy is a number from 1 to 5 at this stage

if Strategy==2
    NumberOfTrials  = centmenu('How many trials do you want to code?', {'1','2','3','4','5'});
elseif Strategy==1
    NumberOfTrials  = 1;
elseif Strategy==3 || Strategy ==4
    Options         = {'10','20','50','100','500'};
    Input           = centmenu('How many trials do you want to code?', Options);
    NumberOfTrials  = str2double(Options(Input));
end
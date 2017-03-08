function [Obs, VD, Inter, Trial]     = ChooseFramesToTest(NewCombinationList, Strategy, NumberOfTrials)
% input a list of trials needing to be tested (n * 4 matrix), which
% stragegy to be tested (1:4), and the number of trials you want to test in one
% go (1:10)

%% needs to be tested

if Strategy==1 % user defined
    Obs = inputdlg('Which Observer?');
    VDNum  = centmenu('What VD?', {'40cm', '1.5m'});
    if VDNum==1
        VD = 0.4;
    elseif VDNum==2
        VD = 1.5;
    end
    Inter=centmenu('Which staircase?', {'RE Reg','RE Van','LE Reg','LE Van'});
    Trial=centmenu('Which trial?',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'});   
elseif Strategy==2 % random
    IndexList=Shuffle(1:length(NewCombinationList));
    Ind=IndexList(1:NumberOfTrials);
    for i=1:NumberOfTrials
        Obs{i}      = num2str(NewCombinationList(Ind(i),1));
        VD(i)       = NewCombinationList(Ind(i),2)./100;
        Inter(i)    = NewCombinationList(Ind(i),3);
        Trial(i)    = NewCombinationList(Ind(i),4);
    end
elseif Strategy==3 || Strategy==4  || Strategy==5 || Strategy==6 || Strategy == 7%% sequential
    for i=1:NumberOfTrials
        Obs{i}      = num2str(NewCombinationList(i,1));
        VD(i)       = NewCombinationList(i,2)./100;
        Inter(i)    = NewCombinationList(i,3);
        Trial(i)    = NewCombinationList(i,4);
    end
end





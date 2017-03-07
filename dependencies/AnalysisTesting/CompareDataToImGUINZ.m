function [res1, res2]   = CompareDataToImGUINZ(DataFile, Im, Inter, Trial, SeqInd, Frame, PossErrorTypes,ScoreErrors, OptNames, Outer1,Inner1, WorkingDistance, Eye, FOV)
% inputs: dataFile from GUINZ (specific)
% outputs - shows image and allows user input to that image

%% set up graphics
figure('Units','normalized','Position',[0 0.45, 0.5 0.35],'Name',sprintf('Obs:%s, VD:%0.1f, Inter:%i, Trial:%i, Frame:%i',DataFile.S_Admin.observerCode,DataFile.S_Admin.ViewingDistanceInM, Inter, Trial, Frame))
imshow(Im, 'InitialMagnification', 100);
hold on

Red                 = [0.8 0.2 0.5];
Green               = [0.2, 0.8,0.5];
Blue                = [0.0 0.4 0.8];
SizeOfLargeTarget   = 3.4; %cm

if DataFile.S_Admin.ViewingDistanceInM==0.4;
    Resolution=640;  
elseif DataFile.S_Admin.ViewingDistanceInM==1.5; 
    Resolution=1920;
end
PixelsPerDegreeOfIm = Resolution/FOV;

%% get information from old analysis 
box = cell2mat(DataFile.S_Data.PositionOfBullsEyeInFrame(SeqInd, Frame));
Rect1 = double([box(1,1),box(1,2), (max(box(:,1))-min(box(:,1))), (max(box(:,2))-min(box(:,2)))]);
rectangle('Position',Rect1,'LineWidth',2, 'EdgeColor',Red);
% Eye from new analysis:
if DataFile.S_Data.EyeTested(SeqInd, Frame)==1
    Eye1='RE';
elseif DataFile.S_Data.EyeTested(SeqInd, Frame)==0
    Eye1='LE';
else
    Eye1='ND';
end
text(645,200, sprintf('Wpx=%0.1f\nWD=%0.1f\nEye=%s', DataFile.S_Data.FrameBullsEyeWidthRecord(SeqInd, Frame), DataFile.S_Data.FrameEstimatedDistanceRecord(SeqInd, Frame), Eye1),'Color', Red) %data from newly aquire image analysis

%% get information from new data:
if sum(isnan(Outer1))==0
    rectangle('Position',Outer1,'LineWidth',2, 'LineStyle',':','EdgeColor',Green, 'Curvature',[1,1]);
    rectangle('Position',Inner1,'LineWidth',2, 'LineStyle',':','EdgeColor',Green, 'Curvature',[1,1]);
    % eye
    if Eye==1
        Eye2='RE';
    elseif Eye==0
        Eye2='LE';
    else
        Eye2='ND';
    end
    
    text(645,320, sprintf('Wpx=%0.1f\nWD=%0.1f\nEye=%s',max([Outer1(3), Outer1(4)]),WorkingDistance, Eye2),'Color', Green) %data from newly aquire image analysis
end
%% What is the child seeing on the screen
% Which optotype?
Opt=DataFile.S_Data.OptotypeTypeDisplayed(Inter, Trial);
if Opt==0
    Opt=10;
end
% How big was it? (pixels)
OptSize=DataFile.S_Data.SizeDisplayed(Inter, Trial);
Response=DataFile.q(Inter).response(1,Trial);
if Response
    Resp='Correct';
else
    Resp='Incorrect';
end

% Was the program in detecting or tracking mode on this frame?
if DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, Frame)==0
    Type='Detecting';
elseif DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, Frame)==1
    Type='Tracking';
else
    Type='Not sure';
end
text(645,40, sprintf('%s, %iPix\n%s\n%s',OptNames{Opt}, OptSize, Resp, Type),'Color',Blue)

%% Get the input from the user to see if it was correct!
if ScoreErrors %want to get detailed information
    [InputBE]      = centmenu('Did it work?',PossErrorTypes);
    res1=InputBE;
else %Just want to find bullseye location
    res1=NaN;
    UserInput = input('What was the solution (1=red correct, 2=green correct, 3=not in frame, 4=child covering, 5=lt''s there, let me show you!\n>');
    if UserInput==1
        CorrectPosition = Rect1;
    elseif UserInput==2
        CorrectPosition = Outer1;
    elseif UserInput==3
        CorrectPosition = 'NotInFrame';
    elseif UserInput==4
        CorrectPosition = 'Obscured';
    elseif UserInput==5 %need to location the bullseye on the picture manually
        [x,y] = ginput(1);
        if Resolution==640 % 40 cm task
            HalfWidth = 40; 
        elseif Resolution==1920 % 150 cm task
            HalfWidth = 30;
        end
        NewIm  =  Im(y-HalfWidth:y+HalfWidth, x-HalfWidth:x+HalfWidth); % think more about this
        [Out, In] = NewImageAnalysis(NewIm, DataFile.S_Admin.ViewingDistanceInM*100, FOV);
        rectangle('Position', [Out(1)+(x-HalfWidth), Out(2)+(y-HalfWidth), Out(3), Out(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
        rectangle('Position', [In(1)+(x-HalfWidth), In(2)+(y-HalfWidth), In(3), In(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
        % add text to show BullsEyeWidth, etc.
        UserInput2 = input('Does that look rigth? (1=yes, 2=No)\n>');
        if UserInput2==1
            CorrectPosition = Out;
        else
            CorrectPosition = 'Did not work';
        end
    end
end
res2 = CorrectPosition;




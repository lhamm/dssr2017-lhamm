function [res1, res2, res3]   = CompareDataToImGUINZ(DataFile, Im, Inter, Trial, SeqInd, Frame, PossErrorTypes,ScoreErrors, OptNames, Outer1,Inner1, WorkingDistance, Eye, FOV)
% inputs: dataFile from GUINZ (specific)
% outputs - shows image and allows user input to that image

%% set up graphics
f = figure('Units','normalized','Position',[0 0.45, 0.5 0.35]);
f.Name = sprintf('Obs:%s, VD:%0.1f, Inter:%i, Trial:%i, Frame:%i', DataFile.S_Admin.observerCode,DataFile.S_Admin.ViewingDistanceInM, Inter, Trial, Frame);
imshow(Im, 'InitialMagnification', 100);
hold on

Red                 = [0.8 0.2 0.5];
Green               = [0.2, 0.8,0.5];
Blue                = [0.0 0.4 0.8];
%SizeOfLargeTarget   = 3.4; %cm

if DataFile.S_Admin.ViewingDistanceInM==0.4;
    Resolution=640;
elseif DataFile.S_Admin.ViewingDistanceInM==1.5;
    Resolution=1920;
end
%PixelsPerDegreeOfIm = Resolution/FOV;

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
%% What is the child seeing on the screen - don't need this at the moment, but might be intersting
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
res3 = 0; % Assume they don't want to go back - this will chanch if they opt for it!
if ScoreErrors %want to get detailed information
    [InputBE]      = centmenu('Did it work?',PossErrorTypes);
    res1=InputBE;
else %Just want to find bullseye location
    res1 = NaN; % not coding type of error
    UserInput = centmenu('Where is the bullseye?', PossErrorTypes);
    %UserInput = input('What was the solution (1=Red correct, 2=Green correct, 3=It''s there - let me show you!, 4=Out of frame, 5=Edge of frame, 6=Child Obscuring\n>');
    if UserInput==7
        res3 = 1;
        CorrectPosition = [];
    elseif UserInput==1
        CorrectPosition = Rect1;
    elseif UserInput==2
        CorrectPosition = Outer1;
    elseif UserInput==4
        CorrectPosition = PossErrorTypes{4}; %'OutofFram';
    elseif UserInput==5 %need to location the bullseye on the picture manually
        CorrectPosition = PossErrorTypes{5}; %'EdgeOfFrame';
    elseif UserInput==6
        CorrectPosition = PossErrorTypes{6}; %'Obscured';
    elseif UserInput==3 %User need to show computer where it is.
        [NewIm, Indx1, Indy1]   = UserDefinedTarget(Im, Resolution);
        [Out, In]               = NewImageAnalysis(NewIm, DataFile.S_Admin.ViewingDistanceInM*100, FOV);
        if sum(isnan(Out))==0
            rectangle('Position', [Out(1)+Indx1, Out(2)+Indy1, Out(3), Out(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
            rectangle('Position', [In(1)+Indx1, In(2)+Indy1, In(3), In(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
        else
            centmenu('Sorry,can you try again?', {'yes'});
            [NewIm, Indx1, Indy1]   = UserDefinedTarget(Im, Resolution);
            [Out, In]               = NewImageAnalysis(NewIm, DataFile.S_Admin.ViewingDistanceInM*100, FOV);
            if sum(isnan(Out))==0
                rectangle('Position', [Out(1)+Indx1, Out(2)+Indy1, Out(3), Out(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
                rectangle('Position', [In(1)+Indx1, In(2)+Indy1, In(3), In(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
            end
        end
        
        % add text to show BullsEyeWidth, etc?
        UserInput2  = centmenu('Does the blue bullseye look accurate',{'yes','no'});
        %UserInput2 = input('Does that look rigth? (1=yes, 2=No)\n>');
        if UserInput2==1
            CorrectPosition = Out;
        else
            centmenu('Sorry,can you try again?', {'yes'});
            [NewIm, Indx1, Indy1]   = UserDefinedTarget(Im, Resolution);
            [Out, In] = NewImageAnalysis(NewIm, DataFile.S_Admin.ViewingDistanceInM*100, FOV);
            if sum(isnan(Out))==0
                rectangle('Position', [Out(1)+Indx1, Out(2)+Indy1, Out(3), Out(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
                rectangle('Position', [In(1)+Indx1, In(2)+Indy1, In(3), In(4)],'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
            end
            % add text to show BullsEyeWidth, etc.
            UserInput3  = centmenu('Does the blue bullseye look accurate',{'yes','no'});
            if UserInput3 ==1
                CorrectPosition = Out;
            else
                centmenu('Please carefully mark the four corners with the mouse', {'ok'})
                [x,y] = ginput(4);
                Rect4 = [min(x), min(y), max(x)-min(x), max(y)-min(y)];
                rectangle('Position', Rect4,'Curvature', [1,1], 'EdgeColor', Blue, 'LineWidth',2)
                UserInput4  = centmenu('Does the blue bullseye look accurate',{'yes','no'});
                if UserInput4 ==1
                    CorrectPosition = Rect4;
                else
                    CorrectPosition = 'Did not work';
                end
            end
        end
    end
end
res2 = CorrectPosition;




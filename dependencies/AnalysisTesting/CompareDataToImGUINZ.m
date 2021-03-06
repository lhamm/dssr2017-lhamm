function [res1]   = CompareDataToImGUINZ(DataFile, Im, ImageCode, Inter, Trial, SeqInd, Frame, PossErrorTypes,OptNames, BEbbox, BullsEyeWidth, EyeTestedGuess, FOV)
% inputs: dataFile from GUINZ (specific)
% outputs - shows image and allows user input to that image

%show image with rectangles from data and get user input to see if it is
figure('Units','normalized','Position',[0.2 0.5 0.2 0.3],'Name',sprintf('Obs:%s, VD:%0.1f, Inter:%i, Trial:%i, Frame:%i',DataFile.S_Admin.observerCode,DataFile.S_Admin.ViewingDistanceInM, Inter, Trial, Frame))
imshow(Im);
hold on

% Chose colours to use:
Red     = [0.8 0.2 0.5];
Green   = [0.2, 0.8,0.5];
Blue    = [0.0 0.4 0.8];

% Get bounding box into correct format for the new data
BEboxPosition = bbox2points(BEbbox);
Rect2=BEboxPosition;
if DataFile.S_Admin.ViewingDistanceInM==0.4;
    Resolution=640;
elseif DataFile.S_Admin.ViewingDistanceInM==1.5;
    Resolution=1920;
end
Rect=cell2mat(DataFile.S_Data.PositionOfBullsEyeInFrame(SeqInd, Frame));

%% get information from new analysis (no tracking - new detect every time)
rectangle('Position',[Rect(1,1),Rect(1,2), (max(Rect(:,1))-min(Rect(:,1))), (max(Rect(:,2))-min(Rect(:,2)))],'LineWidth',2, 'EdgeColor',Red);
text(double(min(Rect2(:,1))+5), double(min(Rect2(:,2))-10), sprintf('%0.1f',BullsEyeWidth),'Color', Green) %data from newly aquire image analysis
%derived from new analysis
EstimatedVD2=calcWD(BullsEyeWidth, 3.4, Resolution, FOV);
text(double(min(Rect2(:,1))+5), double(min(Rect2(:,2))-30), sprintf('%0.1f',EstimatedVD2+2),'Color',Green) %plus 2 because of the gap between eye and glasses 
% Eye from new analysis:
if EyeTestedGuess==1
    Eye2='RE';
elseif EyeTestedGuess==0
    Eye2='LE';
else
    Eye2='ND';
end
% Set up for saying correct or incorrect with eye
if (Inter<=2 && strcmp('RE',Eye2)) || (Inter>2 && strcmp('LE',Eye2));
    EyeColour=Green; FontSize=10;
else
    EyeColour=Red; FontSize=14;
end
text(double(min(Rect2(:,1))+10), double(max(Rect2(:,2))+10), sprintf('%s',Eye2),'Color',Green);

%% get information from original data:
rectangle('Position',[Rect2(1,1),Rect2(1,2), (max(Rect2(:,1))-min(Rect2(:,1))), (max(Rect2(:,2))-min(Rect2(:,2)))],'LineWidth',2, 'LineStyle',':','EdgeColor',Green);
text(double(min(Rect(:,1))+5), double(min(Rect(:,2))-10), sprintf('%0.1f',DataFile.S_Data.FrameBullsEyeWidthRecord(SeqInd, Frame)),'Color',Red) %rect from newly aquired image analysis 
% Actual viewing distance estimation: derived from Width in original data (could also use estimatedVD from original data 
EstimatedVD=calcWD(DataFile.S_Data.FrameBullsEyeWidthRecord(SeqInd, Frame), 3.4, Resolution, FOV);
text(double(min(Rect(:,1))+5), double(min(Rect(:,2))-30), sprintf('%0.1f',EstimatedVD+2),'Color',Red) %plus 2 because of the gap between eye and glasses 
% Eye from original data:
if DataFile.S_Data.EyeTested(SeqInd, Frame)==1
    Eye='RE';
elseif DataFile.S_Data.EyeTested(SeqInd, Frame)==0
    Eye='LE';
else
    Eye='ND';
end
% Set up for saying correct or incorrect with eye
if (Inter<=2 && strcmp('RE',Eye)) || (Inter>2 && strcmp('LE',Eye));
    EyeColour=Green; FontSize=10;
else
    EyeColour=Red; FontSize=14;
end
text(double(min(Rect(:,1))+10), double(max(Rect(:,2))+10), sprintf('%s',Eye),'Color',EyeColour);


%% What is the child seeing on the screen
% Which optotype?
Opt=DataFile.S_Data.OptotypeTypeDisplayed(Inter, Trial);
if Opt==0
    Opt=10;
end
% How big was it? (pixels)
OptSize=DataFile.S_Data.SizeDisplayed(Inter, Trial);
text(10,30, sprintf('%s, %iPix',OptNames{Opt}, OptSize),'Color',Blue)
Response=DataFile.q(Inter).response(1,Trial);
if Response
    Resp='Correct';
    RespColour=Green;
else
    Resp='Incorrect';
    RespColour=Red;
end
text(10,50, sprintf('%s',Resp),'Color',RespColour)

% Was the program in detecting or tracking mode on this frame?
if DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, Frame)==0
    Type='Detecting';
elseif DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, Frame)==1
    Type='Tracking';
else
    Type='Not sure';
end
text(10,10, sprintf('%s',Type),'Color',Blue)

%% Get the input from the user to see if it was correct!
[InputBE]      = centmenu('Did it work?',PossErrorTypes);
res1=InputBE;




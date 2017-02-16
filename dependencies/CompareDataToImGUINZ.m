function [res1, res2, res3]   = CompareDataToImGUINZ(DataFile, Im, ImageCode, Inter, Trial, SeqInd, Frame, PossErrorTypes,OptNames)
%show image with rectangles from data and get user input to see if it is
figure('Units','normalized','Position',[0.2 0.5 0.2 0.3],'Name',sprintf('Obs:%s, VD:%0.1f, Inter:%i, Trial:%i, Frame:%i',DataFile.S_Admin.observerCode,DataFile.S_Admin.ViewingDistanceInM, Inter, Trial, Frame))
imshow(Im);
hold on
Rect=cell2mat(DataFile.S_Data.PositionOfBullsEyeInFrame(SeqInd, Frame));
%[x y w h]
rectangle('Position',[Rect(1,1),Rect(1,2), (max(Rect(:,1))-min(Rect(:,1))), (max(Rect(:,2))-min(Rect(:,2)))],'LineWidth',2, 'EdgeColor','r');  
text(double(min(Rect(:,1))+5), double(min(Rect(:,2))-10), sprintf('%0.1f',DataFile.S_Data.FrameBullsEyeWidthRecord(SeqInd, Frame)),'Color','r') 
%text(0,100, ImageCode,'Color','b');
%What is the child seeing on the screen
Opt=DataFile.S_Data.OptotypeTypeDisplayed(Inter, Trial);
if Opt==0
   Opt=10; 
end
OptSize=DataFile.S_Data.SizeDisplayed(Inter, Trial);
text(10,30, sprintf('%s, %iPix',OptNames{Opt}, OptSize),'Color','g')
Response=DataFile.q(Inter).response(1,Trial);
if Response
   Resp='Correct'; 
   RespColour='g';
else
   Resp='Incorrect';
   RespColour='r';
end
text(10,50, sprintf('%s',Resp),'Color',RespColour)

% Eye
if DataFile.S_Data.EyeTested(Inter*Trial, Frame)==1
    Eye='RE';
elseif DataFile.S_Data.EyeTested(Inter*Trial, Frame)==0
    Eye='LE';
else
    Eye='ND';
end

if (Inter<=2 && strcmp('RE',Eye)) || (Inter>2 && strcmp('LE',Eye)); 
    EyeColour='g'; FontSize=10;
else
    EyeColour='r'; FontSize=14;
end
text(double(min(Rect(:,1))+10), double(max(Rect(:,2))+10), sprintf('%s',Eye),'Color',EyeColour);

%detecting vs tracking
if DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, Frame)==1
    Type='Detecting';
elseif DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, Frame)==0
    Type='Tracking';
else
    Type='Not sure';
end   
text(10,10, sprintf('%s',Type),'Color','g') 

% maybe 'print' these things to the images, and then save the image to a matrix so that it can play in a video?
% maybe leave this interactive part to a separate function called from main script? 
res2=1;
NewError='Na';
[Input]      = centmenu('Was there an error?',{'Yes', 'No', 'exit'});
if Input==1
    [Input2]     = centmenu('What Type of Error?', {PossErrorTypes{1:end},'Add a new option'});
    if Input2==length(PossErrorTypes)+1
        NewError= inputdlg('New error type', 'New Error', 1); %inputdlg(prompt,dlg_title,num_lines,defaultans);
    end
elseif Input==2
    Input2=0;
elseif Input==3
    Input2=NaN;
    [Input3]    = centmenu('Are you sure?', {'Yes','No'});
    if Input3==1 
        res2=0;
    end
end
res1=Input2;
res3=NewError;



%% Initiate screen where bullseye tracking check occurs - we don't currently save info from the checking screen
%this occurs in real time - need to be careful what happens in here.

%set up defaults for trial
runLoop              = true;
numPts               = 0;
BEnumPts             = 0;
MaxFrameCount        = 1000;
frameCount           = 0;
KeepShowingFaceTrack = 1;
BEFound              = 0;
DR                   = 1;
BEDR                 = 1;


% This is only for the first trial, or if the bullseye is lost
if ~exist('BullsEyeWidth','var')
    BullsEyeWidth=NaN;
end

% Change colours for gray screen - in bullseye, but not face check screens
if theInter==2 || theInter==4 %if  vanishing, make blue and red brighter so they are easy to see
    Red=ltRed;
    Blue=ltBlue;
    Tick=TickTexture2;
    Cross=CrossTexture2;
else
    Red=red;
    Blue=blue;
    Tick=TickTexture1;
    Cross=CrossTexture1;
end

% TickRect=[windowRect(3)/2-100 800 50 50];
% CrossRect=[windowRect(3)/2+100, 800, 50 50];

while KeepShowingFaceTrack
   % Screen('DrawTextures',window, Tick,[],TickRect);
   % Screen('DrawTextures',window, Cross,[],TickRect)
    EstimatedVD=[];
    EyeTestedGuess=NaN;
    if BEFound==0
        Screen('DrawText',window,'Smile! We''re trying to find your face',800,windowRect(4)/3.2,lightGray);
    end
    WebcamCaptureAndAnalysis % Detect or track face and bullseye
    faceTex       = Screen('MakeTexture',window, videoFrameGray);
    frameSize     = size(videoFrameGray);
    DestRect      = CenterRect([0 0 frameSize(2) frameSize(1)],windowRect); %may not have frame size
    Screen('DrawTexture', window, faceTex,[],DestRect); %show movie
    if exist('BEbbox','var') && sum(BEbbox)>0 && ~isempty(BEbbox) % Have values for the bullseye
        try
            BullsEye=double([BEbbox(1)+DestRect(1), BEbbox(2)+DestRect(2), BEbbox(3)+BEbbox(1)+DestRect(1), BEbbox(4)+BEbbox(2)+DestRect(2)]);
            Screen('FrameRect',window, Red, BullsEye',2); %added the 2 for stroke width
        catch
        end
        if ~isempty(EstimatedVD)&& ~isnan(EstimatedVD) % This should be only if subpixel analysis worked - check
            % Screen('DrawText',window,sprintf('%0.0f',EstimatedVD),windowRect(3)/2,windowRect(4)*0.75,lightGray);
            Screen('DrawText',window,sprintf('Estimated distance is %0.0fcm from the screen',EstimatedVD),700,windowRect(4)*0.75,lightGray);
            
        else
            BullsEyeWidth=NaN;
        end
    else
        BullsEyeWidth=NaN;
    end
    if FaceTracking && exist('bbox','var') && ~isempty(bbox)  % Have values for face
        Newbbox=round([(DestRect(1:2)+bboxPoints(1,1:2));(DestRect(1:2)+bboxPoints(2,1:2));(DestRect(1:2)+bboxPoints(3,1:2));(DestRect(1:2)+bboxPoints(4,1:2))]);
        Screen('FramePoly', window, Blue, double(Newbbox), 2); %change DestRect to the right parameters form bbox
        FaceWidth=bbox(3);
    else
        FaceWidth=NaN;
    end
    if FaceTracking && exist('bbox','var') && ~isempty(bbox) && exist('BEbbox','var') && sum(BEbbox)>1 && ~isempty(BEbbox); %both!! let's look for which eye
        if BEbbox(1)+(BEbbox(3)) < (bbox(1)+bbox(3)/2)
            WebcamEstOfEyeTested='Looks like you''re testing the Left Eye';
        elseif BEbbox(1) > (bbox(1)+bbox(3)/2)
            WebcamEstOfEyeTested='Looks like you''re testing the Right Eye';
        else
            WebcamEstOfEyeTested='';
        end
    elseif ~isnan(EyeTestedGuess)
        if EyeTestedGuess==1
            Eye='Right Eye';
        elseif EyeTestedGuess==0
            Eye='Left Eye';
        end
        WebcamEstOfEyeTested=sprintf('Looks like you''re testing the %s',Eye);
    else
        WebcamEstOfEyeTested='';
    end
    Screen('DrawText',window,WebcamEstOfEyeTested,850,windowRect(4)*0.80,lightGray);
    Screen('DrawText',window,'Press the ''tick'' button if there is a red rectangle is following the bullseye',250,windowRect(4)/4,Red);
    Screen('Flip',window);
    Screen('Close',faceTex)
    
    %update and assess whether to continue
    [d1, d2, keycode] = KbCheck(-3);
    if d1 %exist('d1','var') %key is has been pressed
        keyName     = KbName(keycode);
        keyFirstChar= keyName(1); %use the first key if multiple pressed
        if keycode(KbName('-'));
            Answer=0;
            KeepShowingFaceTrack=0;
        elseif keycode(KbName('+'));
            Answer=1;
            KeepShowingFaceTrack=0;
        else
            KeepShowingFaceTrack=1;
            d1=0;
        end
        KbReleaseWait
    end
    frameCount=frameCount+1;
    KeepShowingFaceTrack= (frameCount<MaxFrameCount) && ~d1;
    if isempty(EstimatedVD)
        BEFound=0;
    end
end



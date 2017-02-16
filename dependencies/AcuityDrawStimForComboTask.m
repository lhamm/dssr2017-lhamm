%% This script draws the stimulus on the screen and records anything that happens frame by frame 
% (We could put much of this into the initialization file if we separated
% vanishing and regular)

% Lisa Hamm 2016

TargetLetter             = ceil(rand*NoLetters);  %  randomly select target letter - KEY!

%may not be needed:
ThisContrast             = FixedContrast(theInter); % contrast is always the same, so we could get rid of this
MovieLength              = round(StimTime*frameRate); % no longer movies
tWindow                  = tWindowStore; %no longer movies
FrameList                = 1:MovieLength; %no longer movies

%% This is added to make two easier trials at the beginning of each staircase, if the participant gets the correct
% allows Quest to keep a prior close to normal average, but an easy
% introduction for children
GraceTrial=0;
if sum(trialLoop==KeyTrials) % new test
    tTest=tGuess(theInter)+0.3; %show easier trial on first RE presentation
end
if (sum(trialLoop==(KeyTrials+1))) && (response==1)
    tTest=tTest+0.2; %show easier trial on first RE presentation 
end

%% scaling for current presentation
% added in many different measures here, just to be sure we can easily
% recalculate if we want to use a different scaling ratio, etc.
ViewingDistanceCm        = ViewingDistance*100;
BaseSizeDeg              = 2*atand((0.5*ImSize/PixelsPerCm)/(ViewingDistanceCm));     %degrees of target- correct
SizeInDeg                = (10^tTest)*(ScalingForOptRatio/60);% target size in deg - correct
TargetScaling            = SizeInDeg/BaseSizeDeg; % default

%% get optotypes ready to be shown
% which type of test for this trial
StimType                 = TestProtocol(theInter,2);
EyeTested                = TestProtocol(theInter,1);

if StimType==1 % regular
    ScreenBack          = [255 255 255];
    TheIm               = imresize(im1(:,:,TargetLetter),TargetScaling,'bilinear'); %LH used to be bilinear
    SizeInCM            = First(size(TheIm))/PixelsPerCm;
    DegreesOfOpt        = 2*atand((0.5* SizeInCM (1,1))/ViewingDistanceCm);
    MinutesOfStroke     = DegreesOfOpt*60/BoxToStrokeRatio;
    logMAR              = log10(MinutesOfStroke);
        % for regular, we need flankers, here is how we make them:
        FlankerSeperation       = 1.04;
        FlankerSeperationPix    = floor(FlankerSeperation*ImSize*TargetScaling);
        FlankerAngleRad         = linspace(0,2*pi,5);
        FlankerAngleRad         = FlankerAngleRad(1:end-1);
        OffX                    = FlankerSeperationPix.*cos(FlankerAngleRad);
        OffY                    = FlankerSeperationPix.*sin(FlankerAngleRad);
        BarWidth                = 1/BoxToStrokeRatio;
        for f=1:4
            fX=size(im1,1);
            if FlankerOrient(f)==0;
                BarIm=zeros(floor(BarWidth*fX),fX); %LH ask about 32 - removed
                FlankerRect=CenterRect([0 0 round(BarWidth*fX) fX].*TargetScaling.*Rescaling(TargetLetter),windowRect);
            else
                BarIm=zeros(fX,floor(BarWidth*fX));
                FlankerRect=CenterRect([0 0 fX round(BarWidth*fX)].*TargetScaling.*Rescaling(TargetLetter),windowRect);
            end
            destRect(:,f)        = OffsetRect(FlankerRect,OffX(f),OffY(f));
            TheImF               = imresize(BarIm,TargetScaling.*Rescaling(TargetLetter),'bilinear'); %LH maybe 'nearest'?
            imageTextureFlank(f) = Screen('MakeTexture', window, GammCorr(TheImF,gammScr));
        end
    
elseif StimType==2 %vanishing
    ScreenBack          = repmat(255.*(128./255).^(1/gammScr),1,3); %LH used to be [128 128 128]
    TheIm               = imresize(im2(:,:,TargetLetter),TargetScaling,'bilinear'); %LH used to be bilinear
    SizeInCM            = First(size(TheIm))/PixelsPerCm;
    DegreesOfOpt        = 2*atand((0.5*SizeInCM(1,1))/ViewingDistanceCm);
    MinutesOfStroke     = DegreesOfOpt*60/BoxToStrokeRatio;
    logMAR              = log10(MinutesOfStroke);
    
end
imageTextureTemp = Screen('MakeTexture', window, GammCorr(TheIm,gammScr));
TargetRect=CenterRect([0 0 ImSize ImSize].*TargetScaling,windowRect);
    
%% set up for presentation    
KeepShowing         = 1;
FrameNo             = 1; 
TimeAtStartOfFrame  = clock;
StoredMovieFrame    = 1;
videoFrameGrayStore = uint8(zeros(size(videoFrameGray,1),size(videoFrameGray,2),50)); % also changed second index to 2 rather than 1, LH changed this to size(videoFrameGray) not videoFrameGrayStore

%% here is where the optotype is presented
while KeepShowing% they want stim presentation
    % Show stimulus
    Screen('FillRect',     window,  ScreenBack);
    Screen('DrawTexture', window, imageTextureTemp,[],TargetRect,0);
    if TestProtocol(theInter,2)==1
        for i=1:4 %NoFlankers(theInter)
            Screen('DrawTexture', window,  imageTextureFlank(i), [], destRect(:,i), 0);
        end
    end
    Screen('Flip', window);
    
    % Record face location if doing this
    if WebCamTracking
        WebcamCaptureAndAnalysis;
        % store frame images for future analysis
        if mod(FrameNo,6)==0 %save every sixth frame only
         FrameImFileName     = sprintf('%s%c%s%c%s_%s_%d_%d_%d_%s.jpg',saveImagePath,filesep,observerCode,filesep,observerCode,num2str(ViewingDistance),theInter,TrialWithinInter(theInter),FrameNo,MyDate);
         imwrite(videoFrameGray,FrameImFileName);
        end
        % save anything that needs a frame by frame update
        S_Data.FrameTimingRecord(trialLoop,FrameNo)                 = etime(clock, TimeAtStartOfFrame);      
        if FaceTracking
        S_Data.PositionOfFaceInFrame{trialLoop,FrameNo}             = bboxPoints;   % added to structure afterwards b/c cell
        S_Data.FrameFaceDetectRecord(trialLoop,FrameNo)             = DR;
        if exist('c','var')
            S_Data.FrameFaceWidthRecord(trialLoop,FrameNo)          = FaceWidth; %face width
        end
        end
        if BullsEyeTracking
            S_Data.PositionOfBullsEyeInFrame{trialLoop,FrameNo}     = BEbboxPoints; % added to structure afterwards b/c cell
            S_Data.FrameBullsEyeDetectRecord(trialLoop,FrameNo)     = BEFound;
            S_Data.FrameBullsEyeWidthRecord(trialLoop,FrameNo)      = BullsEyeWidth;
            if ~isempty(EstimatedVD)
                S_Data.FrameEstimatedDistanceRecord(trialLoop,FrameNo)  = EstimatedVD; %want it to be [] rather than NaN, so it is not displaying NaN on screen.
            end
            S_Data.EyeTested(trialLoop,FrameNo)                     = EyeTestedGuess;
        end
    end
    % check if there is input from the user, stop trial if so
    [d1, d2, keycode]       = KbCheck(-3); 
    KeepShowing             = ~d1; 
    FrameNo                 = FrameNo+1;
    if isempty(EstimatedVD)
        BEFound=0;
    end
end
% Close textures
Screen('Close',imageTextureTemp);
if StimType==1
    Screen('Close',imageTextureFlank);
end


%% saving images - first type is .mat files - takes too much space!
% StoredMovieFrame       = StoredMovieFrame-1;
% videoFrameGrayStore    = videoFrameGrayStore(:,:,1:StoredMovieFrame); 
% FrameImFileNameAll     = sprintf('%s%c%s%c%s_%s_%d_%d_%s.mat',saveImagePath,filesep,observerCode,filesep,observerCode,num2str(ViewingDistance),theInter,TrialWithinInter(theInter),MyDate);
% save(FrameImFileNameAll,'videoFrameGrayStore');

%% another way of saving - do this if we need better resolution, or if we need the images 'encrypted' to users
% for i=1:StoredMovieFrame
%     FrameImFileName     = sprintf('%s%c%s%c%s_%s_%d_%d_%d_%s.jpg',saveImagePath,filesep,observerCode,filesep,observerCode,num2str(ViewingDistance),theInter,TrialWithinInter(theInter),i,MyDate);
%     imwrite(videoFrameGrayStore(:,:,i),FrameImFileName);
% end

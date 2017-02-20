% Distance changes the resolution and clipping of webcam images, so this
% need to be called for each distance
% Lisa Hamm 2016

%% Set up Webcam for viewing distance
ShowFacTrackingVid = 1; %use 0 to turn off - currently unused
if WebCamTracking
    if Device==4 % make contingencies for other devices if we will be using other things
        if ViewingDistance==.40 %in meters
            ClipSize =[360 640];
            res='640x360'; %imclip needs to be larger, so this will help near be faster
        elseif ViewingDistance==1.50 %in meters
            ClipSize =[360 640];
            res='1920x1080';
        end
        cam            = webcam(1);
        cam.Resolution = res;
        % resolution is related to clip (now should all be the same)
        
        if strcmp('640x360',cam.Resolution)
            PixelsPerDegreeOfIm=8.4434; %calibrated from measurement Estimate is 640/80 (8); %this camera has a field of view of 80 degrees
        elseif strcmp('1280x720',cam.Resolution)
            PixelsPerDegreeOfIm=1280/80; %this camera has a field of view of 80 degrees
        elseif strcmp('1920x1080',cam.Resolution)
            PixelsPerDegreeOfIm=25.2537; %calibrated from measurement %1920/80 - 24; %this camera has a field of view of 80 degrees
        end
        %calculations of size and area in cm, and degrees
        SizeOfSmallTarget=1.1; %cm - in real life
        SizeOfLargeTarget=3.4; %cm  - in real life
        EstLgBullsEyeWidth = (2*atand(SizeOfLargeTarget/(2*ViewingDistance*100)))*PixelsPerDegreeOfIm;
        EstSmBullsEyeWidth = (2*atand(SizeOfSmallTarget/(2*ViewingDistance*100)))*PixelsPerDegreeOfIm;
        UB=ceil(pi*(EstLgBullsEyeWidth/2).^2)-(pi*(EstLgBullsEyeWidth/3).^2); %ara of larger (Pi r squared - area of the next white one)
        LB=floor(pi*(EstSmBullsEyeWidth/2).^2); %area of smaller (Pi r squared)    faceDetector   = vision.CascadeObjectDetector();
        
        %get ready for detecting and tracking
        if FaceTracking
            faceDetector        = vision.CascadeObjectDetector('MinSize', floor([EstLgBullsEyeWidth*3 EstLgBullsEyeWidth*4]), 'MaxSize', ceil([EstLgBullsEyeWidth*7 EstLgBullsEyeWidth*9]), 'ScaleFactor', 1.0001); %vision.CascadeObjectDetector();
            pointTracker        = vision.PointTracker('MaxBidirectionalError', 2);
            numPts              = 0;
            bboxPoints          = NaN(4,2);
        end
        if BullsEyeTracking
            BEpointTracker      = vision.PointTracker('MaxBidirectionalError', 2);
            BEnumPts            = 0;
            BEbboxPoints        = NaN(4,2);
            Gap=2; % 2cm between bullseye and eye
        end
        videoPlayer         = vision.DeployableVideoPlayer('Location', [100 100]); %vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30])

        %save parameters
        S_Admin.ViewingDistanceInM=ViewingDistance; % was not updating
        S_Admin.Webcam=struct('Name',cam.Name, 'Resolution',cam.Resolution, 'WhiteBalanceMode',cam.WhiteBalanceMode,'WhiteBalance',cam.WhiteBalance,'Exposure',cam.Exposure,'ExposureMode',cam.ExposureMode,'Hue',cam.Hue, 'PixPerDeg',PixelsPerDegreeOfIm);
    end
end


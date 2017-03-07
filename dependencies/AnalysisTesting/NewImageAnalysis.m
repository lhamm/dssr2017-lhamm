function [Outer1, Inner1, WorkingDistance, Eye] = NewImageAnalysis(Im, VDcm, FOV)
% Use the images in the dataset to define bullseye and results
% organised to make free parameters easily accessable

% requires the original image, taken at the viewing distances, and webcam settings from the GUINZ experiment
% results are:
% 1 - rectangle for the outer circle [x,y,w,h] in relation to the original image
% 2 - rectangle for the inner circle [x,y,w,h] in relation to the original image
% 3 - estimated working distance in cm with a Gap included to account for distance between the eye and the bullseye
% 4 - estimate of which eye is being tested (0=left, 1=right)


%% information we need - decide if we want this as input rather than set internally
Gap                         = 2; %distance in cm between eye and bullseye
if VDcm==40
    Resolution              = 640;
elseif VDcm==150
    Resolution              = 1920;
end
PixelsPerDegreeOfIm         = Resolution/FOV; %calibrated from measurement. Estimate is 640/80 (8); %this camera has a field of view of 80 degrees
    
SizeOfSmallTarget           = 1.1; %cm - in real life
SizeOfLargeTarget           = 3.4; %cm  - in real life
EstLgBullsEyeWidth          = (2*atand(SizeOfLargeTarget/(2*VDcm)))*PixelsPerDegreeOfIm;
EstSmBullsEyeWidth          = (2*atand(SizeOfSmallTarget/(2*VDcm)))*PixelsPerDegreeOfIm;
UB_area                     = ceil(pi*(EstLgBullsEyeWidth/2).^2)-(pi*(EstLgBullsEyeWidth/3).^2); %ara of larger (Pi r squared - area of the next white one)
LB_area                     = floor(pi*(EstSmBullsEyeWidth/2).^2); %area of smaller (Pi r squared)    faceDetector   = vision.CascadeObjectDetector();

% free parameters:
T1                          = mean(All(Im))-0.5*std(double(All(Im)));   % upper pixel limit
T2                          = mean(All(Im))-0.7*std(double(All(Im)));   % lower pixel limit
UB                          = 3*UB_area;                                % lower area limit
LB                          = LB_area-(0.75*LB_area);                   % upper area limit
Pad                         = EstSmBullsEyeWidth/2;                       % how many pixels to add for subPixel Analysis
Amp                         = 1;                                        % multiplier for the stD of the small image for the subpixel analysis.                                 
Sim                         = 10;                                       % difference between first and last bullseye (in pixels)  

thr                         = 30;                                       % pixel difference needed for edge detection of eye 

% run the image analysis - will need to remove the try catch to find cases it does not work
try
    [x0, y0, A]                 = get_bullseye_center_LH(Im, LB, UB, T1, T2);           % obtain center and bounding box
    PA                          = [A(1)-Pad, A(2)-Pad, A(3)+2*Pad, A(4)+2*Pad];  % add the padded area to do subpixel analysis
    SmallIm                     = imcrop(Im, PA); %(PaddedRect(1):PaddedRect(2), PaddedRect(3):PaddedRect(4)); % clip image
    x                           = x0-PA(1);                                     % find center of bullseye within 'SmallIm'
    y                           = y0-PA(2);                                     % find center of bullseye within 'SmallIm'
    [Outer, Inner]              = SubPixelAnalysis(SmallIm, x, y, Amp, Sim);            % B is [x,y,Width, Height] from subpixel analysis (Amp is 1 if 1StD from the mean of the image)
    % present the results in terms of the original image
    Outer1                      = [Outer(1)+PA(1), Outer(2)+PA(2), Outer(3), Outer(4)];
    Inner1                      = [Inner(1)+PA(1), Inner(2)+PA(2), Inner(3), Inner(4)];
catch
    Outer1 = [NaN NaN NaN NaN];
    Inner1 = [NaN NaN NaN NaN];
    x0     = NaN;
    y0     = NaN;
end



% report largest width, Wording distance, and eye
Larger                      = max(Outer1(3), Outer1(4));
WorkingDistance             = calcWD(Larger, SizeOfLargeTarget, Resolution, FOV) + Gap;
Eye                         = FindEyeFromBird(Im, Outer1, x0, y0, thr);



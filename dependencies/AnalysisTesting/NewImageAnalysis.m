function [res1, res2, res3, res4, res5] = NewImageAnalysis(Im, VDcm, FOV)
% use image to generate a new dataset containing results of new image
% analysis

% information we need - decide if we want this as input rather than set internally
if VDcm==40
    PixelsPerDegreeOfIm=640/FOV; %calibrated from measurement. Estimate is 640/80 (8); %this camera has a field of view of 80 degrees
elseif VDcm==150
    PixelsPerDegreeOfIm=1920/FOV; %calibrated from measurement. %1920/80 - 24; %this camera has a field of view of 80 degrees
end

SizeOfSmallTarget=1.1; %cm - in real life
SizeOfLargeTarget=3.4; %cm  - in real life
EstLgBullsEyeWidth = (2*atand(SizeOfLargeTarget/(2*VDcm)))*PixelsPerDegreeOfIm;
EstSmBullsEyeWidth = (2*atand(SizeOfSmallTarget/(2*VDcm)))*PixelsPerDegreeOfIm;

%free parameters:
T1=mean(All(Im))-0.5*std(double(All(Im)));
T2=mean(All(Im))-0.7*std(double(All(Im)));

UB=ceil(pi*(EstLgBullsEyeWidth/2).^2)-(pi*(EstLgBullsEyeWidth/3).^2); %ara of larger (Pi r squared - area of the next white one)
LB=floor(pi*(EstSmBullsEyeWidth/2).^2); %area of smaller (Pi r squared)    faceDetector   = vision.CascadeObjectDetector();

%run the image analysis
[x0, y0, A] = get_bullseye_center_LH(Im, LB, UB, T1, T2);
BEbbox=A;
try
    [BEFound, BullsEyeWidth, EstimatedVD, EyeTestedGuess]=SubPixelAnalysis(Im,BEbbox,SizeOfLargeTarget,PixelsPerDegreeOfIm, x0, y0);
catch
    BEFound=0; BullsEyeWidth=NaN; EstimatedVD=[]; EyeTestedGuess=NaN;
end

res1=BEbbox;
res2=BEFound;
res3=BullsEyeWidth;
res4=EstimatedVD;
res5=EyeTestedGuess;

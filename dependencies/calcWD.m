function CompGenWD = calcWD(PixelWidth,TargetSize,Resolution,FOV)

%function used to caluclate working distance
%first argument is measure of width of pixels of given selection
%second argumecnt is resolution of device camera
%third argument is size of the image seen by the participant (angle)
%fourth argument is field of view from camera

%PixelWidth      = 32.8; %Lisa to import from results, 15 dummy fixed
halfPixelWidth  = PixelWidth/2;

%FOV             = 80; %can become dynamic
%ScreenReso      = [1920 1080]; %make dynamic so can change between 40 and 150cm
%ClipImgHeight   = 640;
%ImgReso         = (Resolution/ClipImgHeight);
%CameraAngle     = (ClipImgHeight/FOV);

%TargDiam        = 3.4;
halfTargSize    = TargetSize/2; 

CompGenWD       = halfTargSize/tand((halfPixelWidth/(Resolution/FOV)));
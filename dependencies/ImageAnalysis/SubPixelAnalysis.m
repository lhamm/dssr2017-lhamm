%% Subpixel analysis
function [Outer, Inner] = SubPixelAnalysis(Im, x, y, Amp, Sim)
% Get position, width and height of the bullseye based on a sub-pixel analysis
% Im is the clipped image, containing what is suspected to be a bullseye pattern
% x and y are from the centroid analysis - they represent the midpoint of the bullseye
% Amp is a multiplication factor for the standard deviation on the image, the range of pixel values in the image must exceed this limit. 

[hi, wid]           = size(Im); %get width and height
%% Width
interpW             = linspace(1,wid,512);                  % 512 evenly spaced numbers between 1 and width
sliceW              = DoGaussian(Im(round(hi/2),:),0.2);    % cross section of horizontal orientation - fitted
sliceW              = sliceW-mean(sliceW);                  % now mean is 0 - could do width there, scale is correct
sliceWint           = interp1(1:wid, sliceW, interpW);      % interpolate points along gausssian
crossPtsW           = interpW(zc(sliceWint));               % all points which cross 0 
RangeW              = max(sliceW)-min(sliceW);              % require certain range 

% if there are more than 6 cross points, we should take the point which matches our center point as a start 
if sliceW(1,round(x))<0 && length(crossPtsW)>6 % our center point is a dark bit - but we have too many cross points, limit our cross points based on mid point
    crossPtsWinds    = horzcat(find(crossPtsW<x,3), find(crossPtsW>x, 3));
    crossPtsW        = crossPtsW(crossPtsWinds);
end
% now let's check the pixel range is above a certain amount, and also that the outer bulls eye ring is made up of bands of similar width, just to be careful
if length(crossPtsW)==6 && RangeW > Amp*(std(double(All(Im)))) && (abs((crossPtsW(2)-crossPtsW(1))-(crossPtsW(6)-crossPtsW(5)))<Sim) %we have a bullseye
    Bw              = [crossPtsW(end)-crossPtsW(1) crossPtsW(4)-crossPtsW(3)];
    x1              = crossPtsW(1);
    x2              = crossPtsW(3);
else
    Bw              = [NaN NaN];
    x1              = NaN;
    x2              = NaN;
end

%% Get Height
interpH             = linspace(1,hi,512); %512 evenly spaced numbers between 1 and height
sliceH              = DoGaussian(Im(:,round(wid/2)),0.2); %cross section of horizontal orientation - fitted
sliceH              = sliceH-mean(sliceH); %now mean is 0
sliceHint           = interp1(1:hi, sliceH, interpH);  %% this is not working... not sure why!!
crossPtsH           = interpH(zc(sliceHint));
RangeH              = max(sliceH)-min(sliceH);

if sliceH(round(y),1)<0 && length(crossPtsH)>6 % our center point is a dark bit - but we have too many cross points, limit our cross points based on mid point
    crossPtsHinds    = horzcat(find(crossPtsH<y,3), find(crossPtsH>y,3));
    crossPtsH        = crossPtsH(crossPtsHinds);
end

if length(crossPtsH)==6 && RangeH > Amp*std(double(All(Im))) && (abs((crossPtsH(2)-crossPtsH(1))-(crossPtsH(6)-crossPtsH(5)))<Sim) %we have a bullseye
    Bh              = [crossPtsH(end)-crossPtsH(1) crossPtsH(4)-crossPtsH(3)];
    y1              = crossPtsH(1); 
    y2              = crossPtsH(3); 
else
    Bh              = [NaN NaN];
    y1              = NaN;
    y2              = NaN;
end

%% Get output
Outer               = [x1, y1, Bw(1), Bh(1)]; % this should make an eplipse exactly around the larger bullseye, or each should be a NaN
Inner               = [x2, y2, Bw(2), Bh(2)]; % this should make an eplipse exactly around the smaller bullseye, or each should be a NaN


%% Subpixel analysis
function [BEFound, BullsEyeWidth, EstimatedVD, EyeTestedGuess, ClipIm] = SubPixelAnalysis(videoFrameGray,BEbbox,SizeOfLargeTarget,PixelsPerDegreeOfIm, x0, y0)
Gap=2;
ClipIm=videoFrameGray(round(-5+BEbbox(2)+(1:(BEbbox(4)+10))), round(-5+BEbbox(1)+(1:(10+BEbbox(3))))); %get just the bullseye with buffer
[hi, wid]=size(ClipIm); %get width and height
%Width
interpW=linspace(1,wid,512); %512 evenly spaced numbers between 1 and width
sliceW=DoGaussian(ClipIm(round(hi/2),:),0.2); %cross section of horizontal orientation - fitted
% require certain amp
RangeW = max(sliceW)-min(sliceW);
sliceW = sliceW-mean(sliceW); %now mean is 0
sliceWint=interp1(1:wid, sliceW, interpW);
crossPtsW=interpW(zc(sliceWint));

if length(crossPtsW)==6 && RangeW > std(double(All(videoFrameGray))) && (abs((crossPtsW(2)-crossPtsW(1))-(crossPtsW(6)-crossPtsW(5)))<10) %we have a bullseye
    Bw=[crossPtsW(end)-crossPtsW(1) crossPtsW(4)-crossPtsW(3)];
    BullsEyeWidth=Bw(1); % estimate with subpixel analysis
else
    Bw=[];
    BullsEyeWidth=NaN;
end

%Height
interpH=linspace(1,hi,512); %512 evenly spaced numbers between 1 and height
sliceH=DoGaussian(ClipIm(:,round(wid/2)),0.2); %cross section of horizontal orientation - fitted
% require certain amp
RangeH = max(sliceH)-min(sliceH);
sliceH = sliceH-mean(sliceH); %now mean is 0
sliceHint=interp1(1:hi, sliceH, interpH);  %% this is not working... not sure why!!
crossPtsH=interpH(zc(sliceHint));

if length(crossPtsH)==6 && RangeH > std(double(All(videoFrameGray))) && (abs((crossPtsH(2)-crossPtsH(1))-(crossPtsH(6)-crossPtsH(5)))<10) %we have a bullseye
    Bh=[crossPtsH(end)-crossPtsH(1) crossPtsH(4)-crossPtsH(3)];
    BullsEyeHeight=Bh(1); % estimate with subpixel analysis
else
    Bh=[];
    BullsEyeHeight=[];
end
 
%% Sort out whether horizontal or vertical dimention is larger and pick the larger (used to buffer tilt)
if exist('BullsEyeHeight','var') && exist('BullsEyeWidth','var')
    if BullsEyeHeight>BullsEyeWidth
        BullsEyeWidth=BullsEyeHeight; %override with height if it is larger
    end
    EstimatedVD = Gap+(SizeOfLargeTarget/2)/(tand((BullsEyeWidth/2)/PixelsPerDegreeOfIm));
    BEFound=1;
elseif  exist('BullsEyeHeight','var') 
    BullsEyeWidth=BullsEyeHeight;
    EstimatedVD = Gap+(SizeOfLargeTarget/2)/(tand((BullsEyeHeight/2)/PixelsPerDegreeOfIm));
    BEFound=1;
elseif exist('BullsEyeWidth','var');
    EstimatedVD = Gap+(SizeOfLargeTarget/2)/(tand((BullsEyeWidth/2)/PixelsPerDegreeOfIm));
    BEFound=1;
else
    EstimatedVD=[];
    BEFound=0;
end


%% try to find birds - for LE RE distinction
if BEFound==1 && ~isnan(BullsEyeWidth)
    try % to get which eye (look for glasses in a box 6.5x the size of the bullseye
        LookForBirdA      = [x0-(BullsEyeWidth*1.5) y0-(BullsEyeWidth*1.8) BullsEyeWidth*1.5 BullsEyeWidth];
        LookForBirdB      = [x0 y0-(BullsEyeWidth*1.8) BullsEyeWidth*1.5 BullsEyeWidth];
        BirdImA           = uint8(imcrop(videoFrameGray,LookForBirdA));
        BirdImB           = uint8(imcrop(videoFrameGray,LookForBirdB));
        BirdImEdgeA        = edge(BirdImA,'Sobel',0.15);
        BirdImEdgeB        = edge(BirdImB,'Sobel',0.15);
        if (length(find(BirdImEdgeA==1)) - length(find(BirdImEdgeB==1))) > 30
            EyeTestedGuess=0; %0=LE
        elseif (length(find(BirdImEdgeB==1))-length(find(BirdImEdgeA==1))) > 30
            EyeTestedGuess=1; %1=RE
        end  
    catch
      EyeTestedGuess=NaN;  
    end
else
    EyeTestedGuess=NaN;
end
function [resPix, resPixSD] = CalculatePalamedesGUINZ(S_Data,q,ViewingDistanceCm,PixelsPerCm, ScalingR, ScalingV)
%take quest data to make Palamedes thresholds
% palamedes fit
searchGrid.beta     = 3.5; %standard we use
searchGrid.gamma    = 0.10; % effectively 10AFC
searchGrid.lambda   = 0.01; % 1% guessing
PF                  = @PAL_Weibull; %@PAL_CumulativeNormal; %@PAL_Weibull; %
ScalingRatio        = [ScalingR ScalingV ScalingR ScalingV];
%% pixels
maxIntlog=log10(150); %max pixels
minIntlog=log10(5); %min pixels
searchGrid.alpha    = logspace(minIntlog, maxIntlog, 100); % pixels
for i=1:4
    TrialsDone      = length(S_Data.SizeDisplayed);
   % x1              = 1:TrialsDone;
   % y1              = S_Data.SizeDisplayed(i,1:TrialsDone);
    StimLev         = S_Data.SizeDisplayed(i,1:TrialsDone);
    RespVals        = q(i).response(1:TrialsDone);
    UniqueStimLev   = unique(StimLev);
    clear NoTriPerStimLevQ  ResponseSummaryQ
    for j=1:length(UniqueStimLev)
        TheIndexes          = find(StimLev==UniqueStimLev(j));
        NoTriPerStimLevQ(j) = length(TheIndexes);
        ResponseSummaryQ(j) = sum(RespVals(TheIndexes));
    end
    [paramsFitted]          = PAL_PFML_Fit(UniqueStimLev,ResponseSummaryQ,NoTriPerStimLevQ,searchGrid,[1 1 0 0], PF);
    FinalPalThresholdPix(i) = MaxMin(paramsFitted(1), 10.^minIntlog, 10.^maxIntlog);
    B=10;
    [SD] = PAL_PFML_BootstrapParametric(UniqueStimLev, NoTriPerStimLevQ, paramsFitted, [1 1 0 0], B, PF,'searchGrid',searchGrid);
    StDevPix(i)=SD(1);

end

%convert
CIPointsA=FinalPalThresholdPix-2*(StDevPix); %lower CI Threshold in Pix
CIPointsB=FinalPalThresholdPix+2*(StDevPix); %upper CI Threhold in Pix

for i=1:4;    
CIPointsAlogMAR(i) = PixelsToLogMAR(CIPointsA(i), PixelsPerCm, ViewingDistanceCm, ScalingRatio(i));
CIPointsBlogMAR(i) = PixelsToLogMAR(CIPointsB(i), PixelsPerCm, ViewingDistanceCm, ScalingRatio(i));
ThresholdlogMAR(i) = PixelsToLogMAR(FinalPalThresholdPix(i), PixelsPerCm, ViewingDistanceCm, ScalingRatio(i));
end

resPix      = ThresholdlogMAR;
resPixSD    = [CIPointsAlogMAR; CIPointsBlogMAR];



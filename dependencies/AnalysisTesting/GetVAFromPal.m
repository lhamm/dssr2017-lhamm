function [res] = GetVAFromPal(DataFile, ScalingR, ScalingV)
%starts with data file and generates pal fits for acuity and confidence in
%the measures

% requires DataFile in a particular format with structures for a
% psychometric function

% res is a 1x6x2 matrix with observer name and viewing distance, followed
% by VA for RE Reg, RE Van, LE Reg, LEVan.
% in the third dimention, it differentiates between the pal threshold, and
% the confidence from bootstrapping.

%get participant name and viewing distnce
res         = NaN(1,6,3);
res(1,1,:)  = str2double(DataFile.S_Admin.observerCode);
res(1,2,:)  = DataFile.S_Admin.ViewingDistanceInM*100;
res(1,3:6,3) = DataFile.S_Admin.BatteryStatus';
PixelsPerCm = 267/2.54;
ScalingRatios = [ScalingR ScalingV ScalingR ScalingV];
[resPix, resPixSD] = CalculatePalamedesGUINZ(DataFile.S_Data,DataFile.q,res(1,2,1),PixelsPerCm, ScalingR, ScalingV);

TitleInfo   = {'RE Reg' 'RE Van','LE Reg','LE Van'};
close all
figure('Position', [100, 500, 1049, 500]);
for i=1:4
    res(1,i+2,1) = resPix(i);
    res(1,i+2,2) = resPixSD(2,i)-resPix(i);
    
    subplot(2,2,i)
    x           = [1:16];
    y           = log10((2*atand((0.5*DataFile.S_Data.SizeDisplayed(i,1:16)/PixelsPerCm)/res(1,2,1)))*60/ScalingRatios(i));

    hold on
    title(sprintf('%0.1f, VD:%icm, %s, Thresh:%0.2f%s%0.2f',res(1,1), res(1,2), TitleInfo{i}, resPix(i),setstr(177), resPixSD(2,i)-resPix(i)))
    if res(1,i+2,3)==1
        text(10,0.6,'Plugged in')
    else
        text(10,0.6,'Not plugged in')
    end
    axis([1,16,-0.5, 0.8]);
    if resPix(i)>0.2
        patch([1 16 16 1],[-0.5 -0.5 0.8 0.8],[1 0.4 0.6], 'FaceAlpha',0.5);
    end  
    patch([1 16 16 1],[resPixSD(1,i), resPixSD(1,i), resPixSD(2,i), resPixSD(2,i)],[0.2 0.4 1], 'FaceAlpha',0.5);
    plot ([1,16], [resPix(i), resPix(i)],'k--') 
        plot(x,y,'--ko')
    hold off

end

drawnow


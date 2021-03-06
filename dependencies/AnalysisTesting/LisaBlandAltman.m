% Bland Altman plot
function [CorR, CorP, BA] = LisaBlandAltman(Data1, Data2, Data1Text, Data2Text, Codes, PluggedIn)
%plot correlation and bland altman

Ind         = find(~isnan(Data1(:,1)));
Ind1        = Ind(end);
Ind         = find(~isnan(Data2(:,1)));
Ind2        = Ind(end);
Ind         = max(Ind1, Ind2);

Data1       = Data1(1:Ind,1);
Data2       = Data2(1:Ind,1);
Codes       = Codes(1:Ind,1);
PluggedIn   = PluggedIn(1:Ind,1);
%Data1SD     = Data1(1:Ind,2); %maybe use the confidenc when plotting?
%Data2SD     = Data1(1:Ind,2);  %maybe use the confidenc when plotting?

Mean        = (Data1+Data2)/2;
OverallMean = nanmean(Mean);
Diff        = Data1-Data2;
OverallDiff = nanmean(Diff);
UpperCI     = nanmean(Diff)+2*nanstd(Diff);
LowerCI     = nanmean(Diff)-2*nanstd(Diff);
[CorR, CorP] = corr(Data1, Data2);

try
    VeryDifferent = find(abs(Diff)>0.2);
catch
    VeryDifferent = NaN;
end
figure('Position',[100 400 1200 500],'Color',[1 1 1]);

% formatting
FontSize=14;
FontSizeTitle=16;
 
subplot(1,2,1)
scatter(Data1, Data2)
hold on
MinXCor=min(Data1); MaxXCor=max(Data1); MinYCor=min(Data2); MaxYCor=max(Data2);
MinAx=min(MinXCor, MinYCor); MaxAx=max(MaxXCor,MaxYCor);

xlabel(Data1Text, 'FontSize',FontSize)
ylabel(Data2Text, 'FontSize',FontSize)
axis([MinAx-0.1, MaxAx+0.1, MinAx-0.1, MaxAx+0.1]);
for i=1:length(VeryDifferent)
   text(Data1(VeryDifferent(i)), Data2(VeryDifferent(i)), sprintf('%s PI=%i',num2str(Codes(VeryDifferent(i))),PluggedIn(VeryDifferent(i))), 'FontSize',FontSize)  
end
title(sprintf('Correlation R=%0.2f,p=%0.3f', CorR, CorP), 'FontSize',FontSizeTitle)
refline(1,0);
hold off
lsline

subplot (1,2,2)
hold on
scatter(Mean, Diff)
MinXBA=min(Mean); MaxXBA=max(Mean); MinYBA=min(Diff); MaxYBA=max(Diff);
xlabel('Mean of measures', 'FontSize',FontSize)
ylabel('Difference between measures ','FontSize',FontSize)
axis([MinXBA-0.1, MaxXBA+0.1, MinYBA-0.1, MaxYBA+0.1]);
x = [MinXBA-0.1, MinXBA-0.1, MaxXBA+0.1,MaxXBA+0.1];
y = [UpperCI, LowerCI, LowerCI, UpperCI];
patch(x,y,[0.8 0.2 0.6],'FaceAlpha',0.3)
%plot([MinXBA-0.1 MaxXBA+0.1], [UpperCI UpperCI], 'k--', [MinXBA-0.1 MaxXBA+0.1], [LowerCI LowerCI], 'k--',[MinXBA-0.1 MaxXBA+0.1], [OverallDiff OverallDiff], 'k--')
plot([0.2 0.2],[MinYBA-0.1 MaxYBA+0.1],'k-')
for i=1:length(VeryDifferent)
   text(Mean(VeryDifferent(i)), Diff(VeryDifferent(i)), sprintf('%s PI=%i',num2str(Codes(VeryDifferent(i))),PluggedIn(VeryDifferent(i))))  
end
lsline
hold off
BA=2*nanstd(Diff);
title(sprintf('Confidence interval is %0.2f', BA), 'FontSize',FontSizeTitle)

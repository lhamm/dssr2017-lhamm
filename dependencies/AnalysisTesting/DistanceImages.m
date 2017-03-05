% Distance image summary

function DistanceImages(NewWidthSummary, WidthSummary, Obs, VD)

%%  Get all analysis files
 [~, list]                   = system('dir /B /S DataAnalysis*.dat'); %get all analysis files!
 result                      = textscan(list, '%s', 'delimiter','\n');
 AnalysisFiles               = result{1};  
 
 for i=1:length(AnalysisFiles)
     
     
 end

 %% Set up for figure
lastrow = find(isnan(NewWidthSummary(:,1,2)),1);
lastcol = find(isnan(NewWidthSummary(lastrow,:,2)),1);

rows    = ceil(lastrow/4);
cols    = floor(lastrow/rows);
cnt     = 0;
Names   = unique(Obs);
VDs     = sort(unique(VD));
TestType= {'RE Reg', 'RE Van','RE Reg', 'RE Van'};
TypeLocX= [2,17,33,49];
TypeLocY= [180,180,180,180];

for i=1:length(Names)
    for j=1:length(unique(VD))
        cnt=cnt+1;
        TitleList{cnt} = sprintf('%s VD:%0.2f',Names{i}, VDs(j));
    end
end


%% Draw figure
figure('Color', [1 1 1], 'Units','normalized','Position',[0 0 1 1]);
for i=1:lastrow
    subplot(rows, cols, i)
    hold on
    plot(1:64, NewWidthSummary(i,1:64,2),'--o')
    plot(1:64, WidthSummary(i,1:64,2), '--o')
    plot([16 16],[0 200],'k-', [16*2 16*2],[0 200],'k-',[16*3 16*3],[0 200],'k-',[16*4 16*4],[0 200],'k-')
    text(TypeLocX, TypeLocY, TestType, 'FontSize',12, 'Color', [0.5 0.5 0.5]);
    %set(ht1, 'Rotation',90); set(ht2, 'Rotation',90); set(ht3, 'Rotation',90); set(ht4, 'Rotation',90)
    %set(ht1, 'Color', [0.5 0.5 0.5]); set(ht2, 'Color', [0.5 0.5 0.5]); set(ht3, 'Color', [0.5 0.5 0.5]); set(ht4, 'Color', [0.5 0.5 0.5]);
    title(sprintf('%s', TitleList{i}), 'FontSize', 16)
    if i==1
    legend({'New Data', 'Original Data'}, 'location','best');
    end
    if mod(i,2)==0
        refline(0,150);
    else
        refline(0,40);
    end
    axis([1 64 0 200])
end
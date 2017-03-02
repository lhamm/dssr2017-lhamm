% Distance image summary

function DistanceImages(NewWidthSummary, WidthSummary)

lastrow = find(isnan(NewWidthSummary(:,1,2)),1);
lastcol = find(isnan(NewWidthSummary(lastrow,:,2)),1);

rows=ceil(lastrow/4);
cols=floor(lastrow/rows)


for i=1:lastrow
    subplot(rows, cols, i)
    hold on
    plot(1:64, NewWidthSummary(i,1:64,2),'--o')
    plot(1:64, WidthSummary(i,1:64,2), '--o')
    plot([16 16],[0 160],'k-', [16*2 16*2],[0 160],'k-',[16*3 16*3],[0 160],'k-',[16*4 16*4],[0 160],'k-')
    if i==1
    legend({'New Data', 'Original Data'});
    end
end
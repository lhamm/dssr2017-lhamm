% Distance image summary

function DistanceImages(NewWidthSummary, WidthSummary)

lastrow = find(NewWidthSummary(:,1,2)==0,1);
lastcol = find(NewWidthSummary(lastrow,:,2)==0,1);

for i=1:lastrow-1
    subplot(lastrow-1, 1, i)
    hold on
    plot(1:64, WidthSummary(i,1:64,2),'--o')
    plot(1:64, NewWidthSummary(i,1:64,2), '--o')
    plot([16 16],[0 60],'-', [16*2 16*2],[0 60],'-',[16*3 16*3],[0 60],'-',[16*4 16*4],[0 60],'-')
    legend({'New Data', 'Original Data'});
end
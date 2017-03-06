% Distance image summary

function DistanceImages(NewWidthSummary, WidthSummary, Obs, VD, SumDUnique)

%%  Get all analysis files - find good (green), bad (red), and not in frame (gray).
cntOOF  = 0;
cntP    = 0;
cntW    = 0;
for i=1:length(SumDUnique)
    if SumDUnique(i,5)==2 || SumDUnique(i,5)==3 || SumDUnique(i,6)==2 || SumDUnique(i,6)==3 %cases in which bullseye was out of frame or covered.
        cntOOF = cntOOF+1;
        BullsEyeNotInFrame(cntOOF,1:4) = SumDUnique(i,1:4);
    elseif SumDUnique(i,5)==1 || SumDUnique(i,6)==1 % perfect!
        cntP  = cntP+1;
        BullsEyePerfect(cntP,1:4) = SumDUnique(i,1:4);
    elseif SumDUnique(i,5)==7 || SumDUnique(i,6)==9 % incorrect!
        cntW=cntW+1;
        BullsEyeIncorrect(cntW, 1:4) = SumDUnique(i,1:4);
    end
end

BullsEyeNotInFrame  = unique(BullsEyeNotInFrame, 'rows');
BullsEyePerfect     = unique(BullsEyePerfect, 'rows');
BullsEyeIncorrect   = unique(BullsEyeIncorrect, 'rows');

%% Set up for figure
lastrow = find(isnan(NewWidthSummary(:,1,2)),1);
%lastcol = find(isnan(NewWidthSummary(lastrow,:,2)),1);

rows    = ceil(lastrow/4);
cols    = floor(lastrow/rows);
cnt     = 0;
Names   = unique(Obs);
VDs     = sort(unique(VD));
TestType= {'RE Reg', 'RE Van','RE Reg', 'RE Van'};
TypeLocX= [2,17,33,49];
TypeLocY= [180,180,180,180];
cntPatches = 0;

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
    
    a=char(TitleList(i));
    name=str2double(a(1:7));
    ViewD = str2double(a(12:end))*100;
    for j=1:length(BullsEyeNotInFrame)
        if BullsEyeNotInFrame(j,1)==name && BullsEyeNotInFrame(j,2)==ViewD;
            frame = (16-(BullsEyeNotInFrame(j,3)*16)+BullsEyeNotInFrame(j,4));
            colour = [0 0 0];
            x=[frame-0.5 frame+0.5 frame+0.5 frame-0.5];
            y=[0 0 160 160];
            patch(x, y, colour, 'FaceAlpha',0.2, 'LineStyle','none'); 
        end
    end
    
    for j=1:length(BullsEyePerfect)
        if BullsEyePerfect(j,1)==name && BullsEyePerfect(j,2)==ViewD;
            frame = (16-(BullsEyePerfect(j,3)*16)+BullsEyePerfect(j,4));
            colour = [0 0.6 0.4];
            x=[frame-0.5 frame+0.5 frame+0.5 frame-0.5];
            y=[0 0 160 160];
            patch(x, y, colour, 'FaceAlpha',0.2, 'LineStyle','none'); 
        end
    end
    
    for j=1:length(BullsEyeIncorrect)
        if BullsEyeIncorrect(j,1)==name && BullsEyeIncorrect(j,2)==ViewD;
            frame = (16-(BullsEyeIncorrect(j,3)*16)+BullsEyeIncorrect(j,4));
            colour = [0.8 0 0.3];
            x=[frame-0.5 frame+0.5 frame+0.5 frame-0.5];
            y=[0 0 160 160];
            patch(x, y, colour, 'FaceAlpha',0.2, 'LineStyle','none'); 
        end
    end
    
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
function [res] = FindEyeFromBird(Im, Rect, x0, y0, thr)
%% try to find birds - for LE (0) RE (1) distinction
if ~isnan(Rect)
    LookForBirdA      = [x0-(Rect(3)*1.5) y0-(Rect(3)*1.8) Rect(3)*1.5 Rect(3)];
    LookForBirdB      = [x0 y0-(Rect(3)*1.8) Rect(3)*1.5 Rect(3)];
    BirdImA           = uint8(imcrop(Im,LookForBirdA));
    BirdImB           = uint8(imcrop(Im,LookForBirdB));
    BirdImEdgeA       = edge(BirdImA,'Sobel',0.15);
    BirdImEdgeB       = edge(BirdImB,'Sobel',0.15);
    if (length(find(BirdImEdgeA==1)) - length(find(BirdImEdgeB==1))) > thr
        res=0; %0=LE
    elseif (length(find(BirdImEdgeB==1))-length(find(BirdImEdgeA==1))) > thr
        res=1; %1=RE
    else
        res = NaN; %can't be sure.
    end
else
    res = NaN;
end



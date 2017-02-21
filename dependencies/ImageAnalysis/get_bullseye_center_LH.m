function [ x0, y0, A] = get_bullseye_center_LH( im, LB, UB, T1, T2)
%       im   is a grayscale image
%       [T1, T2] are (hystersis thresholds) %
%       [LB, UB] are mimumum/maximum blob-sizes to process
%%
if isempty('T1')
    T1=mean(All(im))+0.5*std(All(im));
end
if isempty('T2')
    T2=mean(All(im))-0.5*std(All(im));
end
if isempty('LB')
    LB=40;
end
if isempty('UB')
    UB=2000;
end

x0 = []; y0 = [];
% get and process blobs
bw      = hysthresh(im, T1, T2);   % hysteresis threshold: All pixels> T1 = edges, adjacent pixels> T2 = edges.
bw      = ~bw;                     % invert
bw      = imclearborder(bw);       % clear light objects connected to image border
bw_out  = xor(bwareaopen(bw, LB),  bwareaopen(bw ,UB)); % remove objects above or below thresholds specified


%ishow(bw); pause
% select regions with centroids within a certain distance of each other\

stats = regionprops(bw_out, 'Centroid','BoundingBox');

cc  = cat(1, stats.Centroid);
bb  = cat(1, stats.BoundingBox);%list from 'bounding box'
x   = cc(:,1); y = cc(:,2); 
N   = length(x);

for i=1:N
    t=((x(i)-x).^2+(y(i)-y).^2);
    t(t==0)=NaN;
    r2(:,i)=t;
end
r2=r2(:);

[ind1 ind2]=meshgrid([1:N],[1:N])    
ind1=ind1(:);
ind2=ind2(:);

 X1  = repmat(x, 1, N);
 Y1  = repmat(y, 1, N);
 X2  = X1'; Y2  = Y1';
% r2  = (X2-X1).^2 + (Y2-Y1).^2;
% r2(logical(eye(N))) = NaN;

if (all(isnan(r2(:)))),
    % could find an answer
    return
end

[min_val, min_ind] = min(r2);% take the closest centroids
min1ind=ind1(min_ind);
min2ind=ind2(min_ind);


x1_candidate = X1(min_ind); x2_candidate = X2(min_ind);
y1_candidate = Y1(min_ind); y2_candidate = Y2(min_ind);
x0 = X1(min_ind); y0 = Y1(min_ind);

[min1ind min2ind]
bb1=bb(min1ind,:);
bb2=bb(min2ind,:);
if (bb1(3)>bb2(3))
A=bb1;
else
  A=bb2;
  
end
% match=0;
% for y=1:length(bb)
%     if bb(y,1)<x0 && bb(y,2)<y0 && (bb(y,1)+ bb(y,3))>x0 && (bb(y,2)+ bb(y,4))>y0
%         match =match+1;
%         possibleMatches(match)=y;
%     end
% end
% A=bb(possibleMatches(1),1); B=bb(possibleMatches(1),2); C=bb(possibleMatches(1),3); D=bb(possibleMatches(1),4);


function [x0, y0, A] = get_bullseye_center_LH( im, LB, UB, T1, T2)
%       im   is a grayscale image
%       [T1, T2] are (hystersis thresholds) %
%       [LB, UB] are mimumum/maximum blob-sizes to process
%%
% if ~exist('T1','var')
%     T1=mean(All(im))+0.05*std(double(All(im))); %started at 0.5 (no) 0.4 (no) 0.3(no) 0.6(no) 0.55 (no) - really close to 1/2
% end
% if ~exist('T2','var')
%     T2=mean(All(im))+0.5*std(double(All(im))); %this one is good so far
% end
% if ~exist('LB','var')
%     LB=30; 
% end
% if ~exist('UB','var')
%     UB=1000;
% end

x0 = []; y0 = [];
%process image
bw      = hysthresh(im, T1, T2);   % hysteresis threshold: All pixels> T1 = edges, adjacent pixels> T2 = edges.
bw      = ~bw;                     % invert
bw      = imclearborder(bw);       % clear light objects connected to image border
bw_out  = bwareafilt(bw,[LB-(0.75*LB) 3*UB]); % (if last number is a 2, it looses the bullseye at 30cm) this strategy uses an area range rather than diameter...

%try to find the blobs which are meaningVful (two concentric circles) - get
%centroid of both, and and bounding box of the larger
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

[ind1 ind2]=meshgrid([1:N],[1:N]);  
ind1=ind1(:);
ind2=ind2(:);

 X1  = repmat(x, 1, N);
 Y1  = repmat(y, 1, N);
 X2  = X1'; Y2  = Y1';
 
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

[min1ind min2ind];
bb1=bb(min1ind,:);
bb2=bb(min2ind,:);
if (bb1(3)>bb2(3))
    A=bb1;
else
    A=bb2;
end



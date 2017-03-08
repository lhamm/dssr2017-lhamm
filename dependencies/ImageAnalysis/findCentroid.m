function [x0,y0,A]= findCentroid(bw_out)
% uses a black and white image with isolated blobs to find two with closest
% center points.

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

[ind1, ind2]=meshgrid([1:N],[1:N]);  
ind1=ind1(:);
ind2=ind2(:);

 X1  = repmat(x, 1, N);
 Y1  = repmat(y, 1, N);
 X2  = X1'; Y2  = Y1';
 
if (all(isnan(r2(:)))),
    % could find an answer
    return
end

[~, min_ind] = min(r2);% take the closest centroids
min1ind=ind1(min_ind);
min2ind=ind2(min_ind);

%x1_candidate = X1(min_ind); x2_candidate = X2(min_ind);
%y1_candidate = Y1(min_ind); y2_candidate = Y2(min_ind);
x0 = X1(min_ind); y0 = Y1(min_ind);

[min1ind min2ind];
bb1=bb(min1ind,:);
bb2=bb(min2ind,:);
if (bb1(3)>bb2(3))
    A=bb1;
else
    A=bb2;
end

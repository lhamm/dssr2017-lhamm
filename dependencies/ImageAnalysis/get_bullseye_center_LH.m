function [x0, y0, A] = get_bullseye_center_LH(im, LB, UB, T1, T2)
%       im   is a grayscale image
%       [T1, T2] are (hystersis thresholds) %
%       [LB, UB] are mimumum/maximum blob-sizes to process

%% Process image
bw          = hysthresh(im, T1, T2);                % hysteresis threshold: All pixels> T1 = edges, adjacent pixels> T2 = edges.
bw          = ~bw;                                  % invert
bw          = imclearborder(bw);                    % clear light objects connected to image border
bw_out      = bwareafilt(bw,[LB UB]);   % (if last number is a 2, it looses the bullseye at 30cm) this strategy uses an area range rather than diameter...
[x0,y0,A]   = findCentroid(bw_out);                 %try to find the blobs which are meaningful (two concentric circles) - get
                                                        %centroid of both, and and bounding box of the larger



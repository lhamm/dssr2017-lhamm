function [NewIm, Indx1, Indy1] = UserDefinedTarget(Im, Resolution)
% get user to define the cropped image within which to look for the target
[x,y] = ginput(1);
if Resolution==640 % 40 cm task
    HalfWidth = 40;
elseif Resolution==1920 % 150 cm task
    HalfWidth = 32;
end
Indy1 = round(MaxMin(y-HalfWidth, 1,size(Im, 1)));
Indy2 = round(MaxMin(y+HalfWidth,Indy1, size(Im, 1)));
Indx1 = round(MaxMin(x-HalfWidth, 1,size(Im, 2)));
Indx2 = round(MaxMin(x+HalfWidth, Indx1, size(Im, 2)));
NewIm  =  Im(Indy1:Indy2, Indx1:Indx2); % think more about this

            
function [Summary, FrameCounter]=MakeGUINZSummary(Summary, Result, SimpleCode, DorENum, FrameCounter)

if DorENum==2
    EyeResult       = Result;
    BEResult        = NaN;
else
    EyeResult       = NaN;
    BEResult        = Result;
end

FrameCounter    = FrameCounter+1;

Summary{FrameCounter,1}=SimpleCode;
Summary{FrameCounter,2}=BEResult;
Summary{FrameCounter,3}=EyeResult;

close all

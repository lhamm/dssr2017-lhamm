function  [res] = PixelsToLogMAR(Pixels, PixelsPerCm, VD, Ratio)

HalfSizeInCm        = (Pixels/PixelsPerCm)/2;
Angle               = 2*atand((HalfSizeInCm/VD)); %in degrees
AngleMin            = Angle*60;
MAR                 = AngleMin/Ratio;
logMAR              = log10(MAR);

res = logMAR;
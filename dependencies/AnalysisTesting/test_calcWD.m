
%% Test for distance
assert(round(calcWD(32.8,3.4,1920,76))==150,'A 32.8p bullseye at "distance settings" should be 150cm away')

%% Test for near
assert(round(calcWD(41.1,3.4,640,76))==40,'A 41.1p bullseye at "near settings" should be 40cm away')

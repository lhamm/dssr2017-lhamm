%% Test for perfectly correlated data

assert(LisaBlandAltman([1;2;3;4], [1;2;3;4], 'First', 'Second', [1;2;3;4],...
    [1;1;1;0])==1, 'This test if for perfectly correlated data')

%% Test for poorly correlated data

assert(LisaBlandAltman([1;2;16;4], [1;2;3;4], 'First', 'Second', [1;2;3;4],...
    [1;1;0;1])==0.427467943631414, 'This test if for perfectly correlated data')
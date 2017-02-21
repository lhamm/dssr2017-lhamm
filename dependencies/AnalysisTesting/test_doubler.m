%% test that a small number doubles correctly
assert(doubler(2)==4, 'Doubler 2 should produce 4');

%% test that a matrix can be doubled
assert(sum(doubler([1,0;0,1])==[2,0;0,2]),/size(, 'Failed to double matrix');

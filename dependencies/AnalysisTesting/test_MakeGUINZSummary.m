%% split
assert(isnan(sum(cell2mat(MakeGUINZSummary({'10001.4,10,NaN'}, ...
12.13, 10001.4, 1, 0)))) == 1, 'There are supposed to be NaNs in the cells')

%% split 
assert(nansum(cell2mat(MakeGUINZSummary({'10001.4,10,NaN'}, ...
12, 10001.4, 1, 0))) == 10013.4, 'There are values in at least one of the columns (excluding the px name)')


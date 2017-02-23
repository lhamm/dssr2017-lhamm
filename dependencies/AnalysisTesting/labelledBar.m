function labelledBar(xLabels, yValues, XLabels, YLabels, Title)
% first argument is a list of strings describing types of errors, but
% nothing about correct
%second argument between zero and one which includes the correct proportion
%and therefore should be one longer than length of PossErrorTypes

%definition
%labelledBar function needs the followig defined to work
    %xLabels            - the x axis criteria (cell array)
    %yVValues           - the corresponding x axis value (cell array)
    %indenpendentvar    - y axis variable (char)
    %dependentvar       - x axis variable (char)
    %xfeat.FontSize     - the font size of the x and y axis headings
    %(double)
    %                   - NOTE: Heading will be same size

figure('Units','normalized', 'Position',[0.01 0.3 0.99 0.5],'Name','Results','Color',[1 1 1])
    
bar (yValues,'FaceColor',[0.69 0.19 0.4]); %Bar Graph Values in Red
set(gca,'XTickLabel',xLabels);
titlefeat           = title (Title);
xfeat               = xlabel (XLabels);
yfeat               = ylabel (YLabels);

xlim([0 numel(xLabels)+1]); % Format of x-axis so looks nice
ylim([floor(min(yValues)) ceil(max(yValues))]); % As working with 
%proprtion y axis should be between 0 and 1


%find out whether there is a better way to write this

titlefeat.FontSize  = xfeat.FontSize + yfeat.FontSize;
xfeat.FontSize      = yfeat.FontSize;
xfeat.FontWeight    = 'bold';
yfeat.FontWeight    = 'bold';

%need to change only first bar - find if this needs to be here or in main
%script
hold on

set(bar(yValues(1),'FaceColor',[0.18 0.55 0.34])); %turns first bar green, remaining stay red

hold off

end




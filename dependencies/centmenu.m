function k = centmenu(xHeader,varargin)
%CENTMENU   Generate a menu of choices for user input, 
% created by Phil Turnbull 10/2015 to make menu.m better, faster, stronger,
% and better for touch and mouse input. 
% varargin can be list of strings, or cell arrays 
%       k = centmenu('Phil is awesome?','Yes','No','Perhaps')
%       %creates a figure with buttons labeled 'Yes', 'No' and 'Perhaps'
%       %Returned as k (i.e. k = 2 implies that the user (incorrectly) selected No).

%check args
if nargin < 2,
    disp(getString(message('MATLAB:uistring:menu:NoMenuItemsToChooseFrom')))
    k=0;
    return;
elseif nargin==2 && iscell(varargin{1}) && ~isempty(varargin{1}),
  ArgsIn = varargin{1}; % a cell array was passed in - this should usually be the case!
elseif nargin==2 && iscell(varargin{1}) && isempty(varargin{1}), %cell array passed, but empty - probably shouldn't be... 
    fprintf(1, 'Error: Proper usage is: k = centmenu(''Phil is awesome?'',''Yes'',''No'',''Perhaps'')\n');
    k=0;
    return;
else
  ArgsIn = varargin;    % use the varargin cell array
end

k = local_GUImenu( xHeader, ArgsIn );

function k = local_GUImenu( xHeader, xcItems )
screensize = get(0,'ScreenSize'); %DPI adjusted 'effective resolution' in newer Matlabs. 
MenuUnits   = 'pixels';     
textPadding = [26 12];               % extra [Width Height] to pad text
uiGap       = 10;                    % space between uicontrols
uiBorder    = 20;                    % space between edge of figure and any uicontrol
winWideMin  = 120;                   % minimum window width necessary to show title 
numItems = length( xcItems );

menuFig = figure( 'WindowStyle', 'normal', ...
                  'Units'       ,MenuUnits, ...
                  'Visible'     ,'off', ...
                  'NumberTitle' ,'off', ...
                  'Name'        ,getString(message('MATLAB:uistring:menu:MENU')), ...
                  'Resize'      ,'off', ...
                  'Colormap'    ,[], ...
                  'MenuBar'     ,'none',...
                  'ToolBar' 	,'none' ...
                   );

hText = uicontrol(...
        'Parent'      ,menuFig, ...
        'Style'       ,'text', ...
        'String'      ,xHeader, ...
        'Units'       ,MenuUnits, ...
        'Position'    ,[ 100 100 100 20 ], ...
        'HorizontalAlignment'  ,'center',...
        'BackgroundColor'  ,get(menuFig,'Color') );

maxsize = get( hText, 'Extent' );
textWide  = maxsize(3);
textHigh  = maxsize(4);
hBtn = zeros(numItems, 1);
for idx = numItems : -1 : 1; % start from top of screen and go down
    n = numItems - idx + 1;  % start from last button and go to last
    % make a button
    hBtn(n) = uicontrol( ...
               'Parent'         ,menuFig, ...
               'Units'          ,MenuUnits, ...
               'Position'       ,[uiBorder uiGap*idx textHigh textWide], ...
                'Callback'       , {@menucallback, n}, ...
               'String'         ,xcItems{n} );
end %   

cAllExtents = get( hBtn, {'Extent'} );  % put all data in a cell array
AllExtents  = cat( 1, cAllExtents{:} ); % convert to an n x 3 matrix
maxsize     = max( AllExtents(:,3:4) ); % calculate the largest width & height
maxsize     = maxsize + textPadding;    % add some blank space around text
btnHigh     = maxsize(2)+10;
btnWide     = maxsize(1)+20;
winTopGap   = screensize(4)/3;       % gap between top of screen and top of figure - top third looks ok for most.
openSpace = screensize(4) - winTopGap - 2*uiBorder - textHigh;
numRows = min( floor( openSpace/(btnHigh + uiGap) ), numItems );
if numRows == 0; numRows = 1; end %just in case a wiseguy gets here
numCols = ceil( numItems/numRows );
winHigh = numRows*(btnHigh + uiGap) + textHigh + 2*uiBorder;
winWide = numCols*(btnWide) + (numCols - 1)*uiGap + 2*uiBorder;
if winWide < (2*uiBorder + textWide);winWide = 2*uiBorder + textWide;btnWide = winWide-uiBorder*2;end %if title is pushing out - make buttons bigger
if winWide < winWideMin;winWide = winWideMin;end %but have a sensible default to make it easier for touch input. 

bottom = (screensize(4))-(winHigh/2 + winTopGap + uiBorder);
winLeftGap  = (screensize(3)/2)-winWide/2; 
set( menuFig, 'Position', [winLeftGap bottom winWide winHigh] );

xPos = ( uiBorder + (0:numCols-1)'*( btnWide + uiGap )*ones(1,numRows) )';
xPos = xPos(1:numItems); % [ all 1st col; all 2nd col; ...; all nth col ]
yPos = ( uiBorder + (numRows-1:-1:0)'*( btnHigh + uiGap )*ones(1,numCols) );
yPos = yPos(1:numItems); % [ rows 1:m; rows 1:m; ...; rows 1:m ]
allBtn   = ones(numItems,1);
uiPosMtx = [ xPos(:), yPos(:), btnWide*allBtn, btnHigh*allBtn ];
cUIPos   = num2cell( uiPosMtx( 1:numItems, : ), 2 );
set( hBtn, {'Position'}, cUIPos );
textWide = winWide - 2*uiBorder;
set( hText, 'Position', [ uiBorder winHigh-uiBorder-textHigh textWide textHigh ] );
set( menuFig, 'Visible', 'on' );
waitfor(menuFig,'userdata') %it's a matlab halting menu - perhaps make vargin in future?

if ishghandle(menuFig)
    k = get(menuFig,'UserData');
    delete(menuFig)
else
    % The figure was deleted without a selection. Return 0.
    k = 0;
end

function menucallback(btn, evd, index)                               
set(gcbf, 'UserData', index);

%% getcurves.m
%
% getcurves() pulls data from all line objects in a specified axis object,
% and returns them as entries in a cell matrix. Also returns the titles of
% each line (empty char string if no title given).
%
% Ex:
%   linedata = getcurves     %Pulls all line data from active axis of
%   current figure
%
%   [linedata, linetitles] = getcurves(my_axis_handle)   %Pulls all line
%   data and titles from axis object specified by "my_axis_handle"

function [curves, legend_values]  = getcurves(hax)

    if nargin < 1
        hax = gca;
    end
    
    h = findobj(hax,'Type','line');
    x=get(h,'Xdata');
    y=get(h,'Ydata');
    legend_values = get(h, 'DisplayName')
    curves = {};
    
    if iscell(x)
        
            for i = 1:length(h)
                curves{i} = vertcat(x{i}, y{i})';
            end
            
            curves = fliplr(curves);
    else
            curves = vertcat(x,y)';
    end

end
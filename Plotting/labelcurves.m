%% Easily add text labels to lines on a matlab figure
%
% Calling this function outputs a list of lines on the plot, and allows the user to
% select specific lines to add labels to via the command window. After
% selecting a line, user is prompted to input text label for the line.
% Finally, the user should click on the figure window to determine the
% location of the text label (click at the bottom-left corner of text
% position). The script will color the text to match the line for high
% readability.
%
% This script calls another script 'colornames.m', which is from the MATLAB
% File Exchange. colornames.m converts rgb values to corresponding english
% words, making it easy to know which curves are which in the console
% output.
%
% https://www.mathworks.com/matlabcentral/fileexchange/48155-convert-between-rgb-and-color-names
%
% script requires colornames.m from the link above, as well as the Open
% Sans font. The font/font size can be changed on the first lines of code.

function labelcurves
    
%% USER INPUTS
    fontsize = 20;              % Font Size
    fontname = 'Open Sans';     % Font Style
    
%% CODE START

    hlines = findobj(gcf, 'type', 'line');
    numlines = length(hlines);
    
    hlegend = findobj(gcf, 'type', 'legend');
    if size(hlegend) == 0
        numlegend = 0;
    else
        numlegend = length(hlegend.String);
    end
    fprintf("\n\nLines available on plot:\n");
    for i = 1:numlines
        fprintf("\nLine %d\t Color: %s", i, char(colornames('xkcd', hlines(i).Color)));
        if i <= numlegend
            fprintf("\t Title: %s", hlegend.String{numlegend-i+1});
        end
    end
    
    fprintf('\n\n');
    
    
    for i = 1:numlines
        
        line_idx = input('Which line would you like to label? (Enter blank to exit): ');

        if ~isempty(line_idx)
            writestring = input('Label text: ', 's');
            fprintf('Click label position on graph.\n\n');
            textcolor = hlines(line_idx).Color;
            gtext(writestring, 'color', textcolor, 'fontsize', fontsize, 'fontname', fontname);
        else
            break;
        end
    end
end
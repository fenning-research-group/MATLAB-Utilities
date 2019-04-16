    %% Documentation
    %   2019-02-2019: prettyplot v1.5 - update 
    %   prettyplot v1.3 - added support for title/axes labels with multiple lines.
    %   prettyplot v1.4 - better options for plot sizing, 'IEEE' default
    %                     formatting added. Draws tick marks on all four
    %                     sides of plot.
    %   prettyplot v1.5 - scale right y-axis ticks to match left y-axis
    %                     ticks.
    %
    %   By default, this script requires:
    %
    %           linspecer https://www.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-+-colormap
    %           Open Sans font https://fonts.google.com/specimen/Open+Sans
    %           
    %   Font can be reassigned in the first lines of code.
    %   
    %   With no user inputs, prettyplot will just change the text fonts,
    %   figure background color to white, and axes format. User inputs can
    %   allow coloring of curves on the plot
    %
    %   Valid inputs:
    %       'colorful':     uses a divergent colormap to make each curve
    %                       distinguishable
    %       'sequential':   uses a sequential colormap, one color with
    %                       varying hues. default is blue
    %                       
    %                        IF 'sequential' is flagged, it can be followed 
    %                        by 'blue', 'red', 'green', or 'gray' to
    %                        determine the color.
    %       
    %       'flip':         reverses the color pattern for any of the above
    %                       options                
    %
    %       'choosecolors': opens a prompt in the command window that
    %                       allows the user to assign sequential colors or 
    %                       black to subsets of the curves on a plot. This 
    %                       allows multiple series of data to be colored
    %                       appropriately.
    %       
    %       'nointerp':     Disable LaTEX interpreter for legend entry
    %                       (underscores to subscript, etc)
    %
    %       'nolinestyle': Converts all lines to solid, useful when
    %                       plotting on 2 axes autoformats lines to dot/dash/etc.
    %
    %       'small':        Resizes image to 50% dimensions, better text
    %                       readability for small figures
    %
    %       'wide' :        Resizes image for landscape fit
    %
    %       'IEEE' :        Formatting for IEEE paper
    %       
    %       'twoplots' :    Good for subplots
    %% Function Start
function prettyplot(varargin)
    %% User Inputs
    axesfont = 'Open Sans'; %used for all text except axes labels and figure title
    axesfontsize = 16; 
    titlefont = 'Open Sans'; %used for both axes labels and figure title
    labelfontsize = 20;
    titlefontsize = 20;
    linewidth = 1.5;
    
    %% Parse Input Arguments
    %default selections
    sequential = 0;
    linecolor = 'blue';
    flip = 0;
    choosecolors = 0;
    colorful = 0;
    legend_interp = 1;
    nolineformat = 0;
    smallfig = 0;
    widefig = 0;    
    titlevisibility = 'on'; %set to either 'on' or 'off'
    monitor_ratio = 0.3;    %how big to display figure on monitor, relative to monitor pixel dimensions
    plot_aspect_ratio_x = 1;
    plot_aspect_ratio_y = 1;
    plot_aspect_ratio_z = 1;
    match_to_left_ticks = 1;
    skipNext = false;
    
    for i = 1:nargin
        if skipNext
            skipNext = false;
            continue;
        end
        
        switch(varargin{i})
            case 'colorful'
                colorful = 1;
            case 'sequential'
                sequential = 1;
                if (nargin > i) && sum(strcmp(varargin{i+1}, {'blue','red','green','gray'}))
                    linecolor = varargin{i+1};
                    skipNext = true;
                end
            case 'flip'
                flip = 1;
            case 'choosecolors'
                choosecolors = 1;   
            case 'nointerp'
                legend_interp = 0;
            case 'nolinestyle'
                nolineformat = 1;
            case 'small'
                monitor_ratio = 0.5;
                axesfontsize = 12;
                labelfontsize = 16;
            case 'wide'
                monitor_ratio = 0.8;
                plot_aspect_ratio_y = 9/16;
            case 'IEEE'
                titlevisibility = 'off';
%                 screen_x_dimension = 51.69; %cm width of screen for dell 24" monitor
                screen_x_dimension = 64.62; %cm width of screen for dell 30" monitor
                paper_column_width = 8.89;  %cm width of column in IEEE paper format
                monitor_ratio = paper_column_width/screen_x_dimension;
                axesfontsize = 10;
                labelfontsize = 12;
                linewidth = 1;
            case 'twoplots'
                axesfontsize = 12;
                labelfontsize = 12;
                titlefontsize = 12;
        end
    end
    
    %% Select Figure and Main Axis Handles
    % select figure handle
    hfig = gcf;
    
    % select correct main axes, which may be tricky when re-running
    %prettyplot on a figure with dummy axes added to 
    hax = gca;
    
    xlim_orig = xlim;
    ylim_orig = ylim;

    %% Resize and center figure on screen

    screensize = get(0,'screensize');    
    
    if screensize(3) > screensize(4)
        figure_size_x = screensize(3)*monitor_ratio;
        figure_size_y = figure_size_x * plot_aspect_ratio_x / plot_aspect_ratio_y;
    else
        figure_size_y = screensize(4)*monitor_ratio;
        figure_size_x = figure_size_x * plot_aspect_ratio_y / plot_aspect_ratio_x;
    end
    
    figsize = round([figure_size_x figure_size_y]);



%     figsize = [750 750];            %for powerpoint compatibility
    oldpos = hfig.Position;
    newpos = [(screensize(3:4)-figsize)/2 figsize];
    
    %If figure is displayed on second monitor, resize + display on the
    %second monitor.
    if oldpos(1) > screensize(3)
        if screensize(1,3) > screensize(1,4)
            figure_size_x = screensize(1,3)*monitor_ratio;
            figure_size_y = figure_size_x * plot_aspect_ratio_x / plot_aspect_ratio_y;
        else
            figure_size_y = screensize(1,4)*monitor_ratio;
            figure_size_x = figure_size_x * plot_aspect_ratio_y / plot_aspect_ratio_x;
        end
        figsize = round([figure_size_x figure_size_y]);

        
%         figsize = [750 750];            %for powerpoint compatibility
        
        newpos = [(screensize(1, 3:4) - figsize)/2 + screensize(1,1:2) figsize];
        
    end
    
    set(hfig,...
        'units',        'pixels',...
        'color',        'w',...
        'WindowStyle',  'Normal',...
        'Position',     newpos);
    figure(hfig);     
    
    %% Line Formatting
    
    %find and format lines
    hlines = findobj(hfig, 'type', 'line');
    numlines = length(hlines);
    
    %change line widths regardless of color options
    for i = 1:numlines
        set(hlines(i),'linewidth', linewidth);
        if nolineformat
            set(hlines(i), 'linestyle', '-');
        end
    end
    
    %recolor lines if flagged
    if choosecolors
        curvecolors;
    elseif (sequential + colorful)
        if sequential == 1
            exclude_light_offset = max(1, round(0.3*numlines));
            linecolors = linspecer(numlines+exclude_light_offset, linecolor);
            linecolors = linecolors(exclude_light_offset+1:end, :);     
        elseif colorful == 1
            linecolors = linspecer(numlines);
        end

        if flip == 1
            linecolors = flipud(linecolors);
        end  
        
        for i = 1:numlines
            set(hlines(i), 'color', linecolors(i,:));
        end
    end
    
    %% Text Formatting
    
    %find and format title/labels
    function clean = cleanlabel(dirty)
        startpt = strfind(dirty, '\font');
        endpt = strfind(dirty, '}');
        if ~(isempty(startpt) && isempty(endpt))
            clean = dirty(endpt(length(startpt))+1:end);
        else
            clean = dirty;
        end
    end

    %modify title/labels in appropriate fashion whether single line or cell
    %array of multiple lines
    
    function newstring = adjuststring(oldstring, font, fontsize)
        if iscell(oldstring)
            for i = 1:length(oldstring)
                oldstring{i} = ['\fontname{' font '}\fontsize{' sprintf('%d', fontsize) '}' cleanlabel(oldstring{i})];
            end
        else
            oldstring = ['\fontname{' font '}\fontsize{' sprintf('%d', fontsize) '}' cleanlabel(oldstring)];
        end
        newstring = oldstring;
    end

    %find and format other text
    htext = findobj(hfig, 'type', 'text');
    if ~isempty(htext)
        set(htext,...
            'FontSize', labelfontsize,...
            'FontName', axesfont);
    end
    
    
    
    % axis label/tick style
    set(hax,...
        'FontSize',                 axesfontsize  ,...
        'TitleFontWeight',          'bold',...
        'TickLabelInterpreter',     'tex',...
        'FontName',                 axesfont,...
        'TickDir',                  'in' ,...
        'XMinorTick',               'on',...
        'Xgrid',                    'on',...
        'GridLineStyle',            ':',...
        'GridAlpha',                0.2);
    
    % plot title
    tstr = adjuststring(hax.Title.String, titlefont, titlefontsize);
%     if hax.YAxis.Exponent ~= 0      %if there is an exponent on y axis units, raise the title by one line to not overlap exponent label
%         if ~iscell(tstr)
%             tstr = {tstr, ' '};
%         elseif ~strcmp(tstr{end}, ' ')
%             tstr = {tstr, ' '};
%         end
%     end
    title(hax, tstr);
    
    set(hax.Title,...
        'Visible', titlevisibility);
    
    %X-axis label    
    xlabel(hax, ['\fontname{' titlefont '}\fontsize{' sprintf('%d', labelfontsize) '}' cleanlabel(hax.XLabel.String)]);  
    
    % Y-axis label(s) depending on whether one or two y-axes are used. Ends
    % with same y axis as originally selected.    
    if length(hax.YAxis) == 2      
        
        %formatting for left and right axes
        if strcmp(hax.YAxisLocation,'left')
            yyaxis right;
            set(hax,...
                'YColor',       [0 0 0],...
                'YMinorTick',   'on'...
                );
            ystr = adjuststring(hax.YLabel.String, titlefont, labelfontsize);
            ylabel(ystr);
            set(hax.YLabel,...
                'Rotation', 90);           
            
            yyaxis left;
            set(hax,...
                'YColor',       [0 0 0],...
                'YMinorTick',   'on',...
                'Ygrid',        'on'...
                );            
            ystr = adjuststring(hax.YLabel.String, titlefont, labelfontsize);
            ylabel(ystr);
            set(hax.YLabel,...
                'Rotation', 90);   
        else         %switches left/right to end on correct axis
            yyaxis left;
            set(hax,...
                'YColor',       [0 0 0],...
                'YMinorTick',   'on',...
                'Ygrid',        'on'...
                );   
            ystr = adjuststring(hax.YLabel.String, titlefont, labelfontsize);
            ylabel(ystr);
            set(hax.YLabel,...
                'Rotation', 90);           
            
            yyaxis right;
            set(hax,...
                'YColor',       [0 0 0],...
                'YMinorTick',   'on'...
                );
            ystr = adjuststring(hax.YLabel.String, titlefont, labelfontsize);
            ylabel(ystr);
            set(hax.YLabel,...
                'Rotation', 90); 
        end
        
        %adjust tick spacing on right axis to match that on left if flagged
        if(match_to_left_ticks)
            ticks_left = hax.YAxis(1).TickValues;
            minorticks_left = hax.YAxis(1).MinorTickValues;

            tick_spacing = (ticks_left - min(ticks_left)) / (max(ticks_left) - min(ticks_left));                        %normalized to percent change between major ticks
            minortick_spacing = (minorticks_left - min(ticks_left)) / (max(ticks_left) - min(ticks_left));              %normalized to percent change between minor ticks

            ticks_right = hax.YAxis(2).TickValues;                                                                      %get original ticks on right axis
            minorticks_right = hax.YAxis(2).MinorTickValues;    

            hax.YAxis(2).TickValues = min(ticks_right) + (max(ticks_right) - min(ticks_right))*tick_spacing;            %set tick spacing on right axis to match that on left axis
            hax.YAxis(2).MinorTickValues = min(ticks_right) + (max(ticks_right) - min(ticks_right))*minortick_spacing;     
        end
    else
        set(hax, 'YColor', [0 0 0]);
        ystr = adjuststring(hax.YLabel.String, titlefont, labelfontsize);
        ylabel(hax, ystr);
        set(hax.YLabel,...
            'Rotation', 90);   
    end
    
    box on;     %draws tick marks on all four sides of plot
    
%     pbaspect(allax(ax_idx), [plot_aspect_ratio_x plot_aspect_ratio_y plot_aspect_ratio_z]);
    
    xlim(xlim_orig);
    ylim(ylim_orig);
    
    %% Legend
    hleg = findobj(hfig, 'Type', 'Legend');
%     set(hleg, ...
%         'Location',     'best',...
%         'FontSize',     labelfontsize);
    if ~legend_interp
        set(hleg, 'Interpreter', 'none');
    end
    
    %% Curve Color Selection Helper Function
    %curvecolors function allows assignment of sequential colormaps to
    %subsets of curves on a single plot. Assignment is done by user via command line
    %window. Used to have multiple series distinguished on one plot.
    function curvecolors
        fprintf("\n\n\n\n\n");
        hfig = gcf;

        colorlist = {'blue', 'red', 'green', 'gray', 'black'};

        %find and format lines
        numlines = length(hlines);
        
        hlegend = findobj(hfig, 'type', 'legend');
        if size(hlegend) == 0
            numlegend = 0;
        else
            numlegend = length(hlegend.String);
        end
        fprintf("Lines available on plot:\n\n");
        for j = 1:numlines
            fprintf("Line %d", j);
            if j > (numlines - numlegend)
                fprintf(":%s", hlegend.String{numlegend-j+1 + (numlines-numlegend)});
            end
            fprintf("\n");
        end

        fprintf('\nWhich lines should be assigned to the following colors? (ie: green:[1,2])\n\n');
        for k = 1:length(colorlist)
            list = input(sprintf('%s:', colorlist{k}));
            num = length(list);
            if strcmp(colorlist{k},'black')
                for j = 1:num
                    set(hlines(list(j)), 'color', 'k');
                end
            elseif num > 0

                if num == 1
                    colors = linspecer(9,colorlist{k});
                    set(hlines(list(1)), 'color', colors(7,:));
                else 
                    exclude_light_offset = max(1, round(0.3*num));
                    colors = flipud(linspecer(num+2*exclude_light_offset, colorlist{k}));                    
                    colors = colors(exclude_light_offset:end,:);
                    
%                     if flip
%                         flipud(colors);
%                     end

                    for j = 1:num

                        set(hlines(list(j)), 'color', colors(num-j+1,:));
        %                 set(hlines(list(j)), 'color', colors(num,:), 'linewidth', linewidth);

                    end
                end
            end

            numlines = numlines - num;
            if numlines <= 0
                break;
            end
        end
    end
    
end
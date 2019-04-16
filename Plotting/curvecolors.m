function curvecolors
%     clc;
    fprintf("\n\n\n\n\n");
    hfig = gcf;
    linewidth = 1;
    
    colorlist = {'blue', 'red', 'green', 'gray', 'black'};
    
    %find and format lines
    hlines = findobj(hfig, 'type', 'line');
    numlines = length(hlines);
    
    hlegend = findobj(hfig, 'type', 'legend');
    if size(hlegend) == 0
        numlegend = 0;
    else
        numlegend = length(hlegend.String);
    end
    fprintf("Lines available on plot:\n\n");
    for i = 1:numlines
        fprintf("Line %d", i);
        if i <= numlegend
            fprintf(":%s", hlegend.String{numlegend-i+1});
        end
        fprintf("\n");
    end
    
    fprintf('\nWhich lines should be assigned to the following colors? (ie: green:[1,2])\n\n');
    for i = 1:length(colorlist)
        list = input(sprintf('%s:', colorlist{i}));
        num = length(list);
        if strcmp(colorlist{i},'black')
            for j = 1:num
                set(hlines(list(j)), 'color', 'k', 'linewidth', linewidth);
            end
        elseif num > 0
            exclude_light_offset = max(1, round(0.3*num));
            colors = flipud(linspecer(num+2*exclude_light_offset, colorlist{i}));
%             colors = linspecer(num+2*exclude_light_offset, colorlist{i});

%             if num == 1
%                 set(hlines(list(1)), 'color', colors(2,:), 'linewidth', linewidth);
%             else 
                colors = colors(exclude_light_offset:end,:);
                for j = 1:num

                    set(hlines(list(j)), 'color', colors(num-j+1,:), 'linewidth', linewidth);
    %                 set(hlines(list(j)), 'color', colors(num,:), 'linewidth', linewidth);

                end
%             end
        end
                
        numlines = numlines - num;
        if numlines <= 0
            break;
        end
    end
end
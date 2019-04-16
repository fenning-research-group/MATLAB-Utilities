function chooselegend(indices, labels)
    hax = gca;
    
    lines = [];
    for idx = 1:length(hax.Children)
        if strcmp(class(hax.Children(idx)), 'matlab.graphics.chart.primitive.Line')
            lines = [lines; hax.Children(idx)];
        end
    end
    
    legend(lines(indices), labels);
end
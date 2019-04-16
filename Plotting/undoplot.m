function undoplot
    h = findobj('type', 'line');
    delete(h(1));
end
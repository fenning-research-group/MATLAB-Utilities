function undotext
    text_handles = findobj(gcf, 'type', 'text');
    delete(text_handles(1));
    
end
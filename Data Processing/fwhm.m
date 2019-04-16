function fwhm_ans = fwhm(x, y)
    [ymax, ymax_idx] = max(y);
    x_1 = find(y(1:ymax_idx)<ymax/2, 1, 'last');
    x_2 = find(y(ymax_idx:end)<ymax/2, 1, 'first') + ymax_idx;

    if isempty(x_1) || isempty (x_2)
        fwhm_ans = NaN;
    else
        fwhm_ans = x(x_2) - x(x_1);    
    end
end
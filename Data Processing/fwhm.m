%% fwhm(x,y)
%
% Finds the full-width half-max of the largest peak in the vector "y" supplied by the user. Reports this 
% value in terms of the vector "x" supplied by the user.
%
% Example:
%
%	assume spectral data stored in "wavelengths", "transmission"
%
%	my_fwhm = fwhm(wavelengths, transmission)
%
%   output: my_fwhm = 134   (this is in units of "wavelengths")
%
% Rishi Kumar 2019-04-18

function fwhm_ans = fwhm(x, y)
    [ymax, ymax_idx] = max(y);
    x_1 = find(y(1:ymax_idx)<ymax/2, 1, 'last');
    x_2 = find(y(ymax_idx:end)<ymax/2, 1, 'first') + ymax_idx;

    if isempty(x_1) || isempty (x_2)
        fwhm_ans = NaN;
        error('No FWHM found!')
    else
        fwhm_ans = x(x_2) - x(x_1);    
    end
end
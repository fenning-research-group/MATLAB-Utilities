function [spectra] = normalize(spectra, baselinefilter)

    if nargin == 2
        for i = 1:size(spectra, 2)
            spectra(:,i) = spectra(:,i) - sgolayfilt(spectra(:,i), 1, 151);
        end
    end
    
    spectra = spectra - min(spectra(:));
    spectra = spectra ./ (max(spectra(:)) - min(spectra(:)));
end

function [data_adjusted, unitlabel] = SIunitadjust(data, include_cm)

    SI_labels = {'G', 'M', 'k', '', 'm', '\mu', 'n', 'p'};
    SI_power = [9,6,3,0,-3,-6,-9,-12];
    
    if nargin >= 2
        SI_labels = {'G', 'M', 'k', '', 'c', 'm', '\mu', 'n', 'p'};
        SI_power = [9,6,3,0,-2,-3,-6,-9,-12];
    end
    
    check = abs(min(data(data~=0)));
    
    for i = 1:length(SI_power)
        if mod(check, 10^SI_power(i)) ~= check
            data_adjusted = data*10^-SI_power(i);
            unitlabel = SI_labels{i};
            break;
        end
    end
end
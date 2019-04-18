% SIunitadjust.m
%
% This function takes raw data in the base SI unit, finds the preferred SI unit
% with the lowest number of leading decimal places, and returns data scaled to the 
% preferred SI unit. Also returns the SI prefix for adjusted data.
%
% Example1:
%
%   travel_distance = 12000;        (in base SI unit, in this case meters)
%
%   [travel_distance_SI, SI_unit] = SIunitadjust(travel_distance)
%
%   Output: travel_distance_SI = 12         (closest SI unit is kilo, returns travel_distance in terms of kilometers)
%           SI_unit = 'k'                   (prefix for SI unit of adjusted data)
%       
% Optional flag second input to allow centi- prefix.
%   ie [travel_distance_SI, SI_unit]  SIunitadjust(travel_distance, 1)   (the "1" adds centimeters as a considered output)
%
% Rishi Kumar 2019-04-18

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
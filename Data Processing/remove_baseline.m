%% remove_baseline.m
%
%  Takes a single vector, and finds a rough "baseline". This is done by
%  smoothing the vector with progressively wider savitsky-golay filters,
%  and taking the baseline at each value to be the lower of either the SG
%  filter value or the actual data value.
%
%  input arguments:
%       spectrum:   the vector of data to be baseline fit
%       degree:     arbitrary number describing how aggressively to fit
%                   baseline. smaller = more aggressive. number must be between 2 and
%                   the length of spectrum
%       plot:       set to either 'on' or 'off. if 'on', generates plot of vector +
%                   baseline 
%
%   output arguments:
%       corrected_spectrum: spectrum with baseline removed
%       base:               baseline vector
%
%   example:
%       [spec_corrected, baseline] = remove_baseline(spec, 'degree', 10, 'plot', 'on');
%

function [corrected_spectrum, base] = remove_baseline(spectrum, varargin)

%% input parsing
default_degree = 5;
expectedPlotflags = {'off', 'on'};

p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 1);
addRequired(p,'spectrum',@(x) isnumeric(x));
addOptional(p,'degree',default_degree,validScalarPosNum);
addParameter(p,'plot','off',@(x) any(validatestring(x, expectedPlotflags)));
parse(p,spectrum,varargin{:});

spectrum = p.Results.spectrum;
if size(spectrum, 1) == 1
    spectrum = spectrum';
end
degree = p.Results.degree;
plotflag = p.Results.plot;

%% program start
l = length(spectrum);
lp=ceil(0.5*l);

initial_Spectrum=[ones(lp,1)*spectrum(1) ; spectrum ; ones(lp,1)*spectrum(l)];

l2=length(initial_Spectrum);  

S=initial_Spectrum;

n=1;

flag1=0;

while flag1==0
    
    n=n+2;

    i=(n-1)/2;
    
    [Baseline, stripping]=peak_stripping(S,n);

    A(i)=trapz(S-Baseline);

    Stripped_Spectrum{i}=Baseline;

    S=Baseline;
   
    if i>degree
        if A(i-1)<A(i-2) && A(i-1)<A(i)
            i_min=i-1;
            flag1=1;
        end 
    end

end


base=Stripped_Spectrum{i_min}; 

corrected_spectrum=initial_Spectrum-base;

corrected_spectrum=corrected_spectrum(lp+1:lp+l);
base=base(lp+1:lp+l);

if strcmp(plotflag, 'on')
    figure, hold on;
    plot(spectrum, 'k');
    plot(base, 'r');
    title(sprintf('Baseline Fit with Degree = %d', degree));
end

end

function [Baseline, stripping]=peak_stripping(Spectrum,Window)
stripping=0;

y=sgolayfilt(Spectrum,0,Window);

n=length(Spectrum);

Baseline=zeros(n,1);

for i=1:1:n
   if Spectrum(i)>y(i)
       stripping=1;
       Baseline(i)=y(i);
   else
       Baseline(i)=Spectrum(i);
   end
       
    
    
end


end
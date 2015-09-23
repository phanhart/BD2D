function delta = computeDelta(A, B, dimension)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2015/9/22
%
% Computes the delta PSNR, delta base layer bit rate, and delta enhancement
% layer bit rate.

switch dimension
    case 'PSNR'
        axis = {'rB' 'rE' 'D'};
        data = {'rE' 'rB' 'IB' ; 'rB' 'rE' 'IE'};
    case 'base'
        axis = {'rE' 'D' 'rB'};
        data = {'D' 'rE' 'IE' ; 'rE' 'D' 'IB'};
    case 'enhancement'
        axis = {'rB' 'D' 'rE'};
        data = {'D' 'rB' 'IB' ; 'rB' 'D' 'IE'};
    otherwise
        error('Dimension `%s` unknown.\n', dimension);
end

% Fit each R^2-D surface with a cubic surface
A.f = fit([A.(axis{1}) A.(axis{2})], A.(axis{3}), 'poly33');
B.f = fit([B.(axis{1}) B.(axis{2})], B.(axis{3}), 'poly33');

% Evaluate the integral using a finite sum
[X, Y] = sampleInteresctedArea({A, B}, data);
delta = mean(B.f(X, Y) - A.f(X, Y));

% Don't forget the transformation for delta rate
switch dimension
    case {'base', 'enhancement'}
        delta = 100*(10^delta - 1);
end

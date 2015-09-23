function [f, yExtrema, xRange] = findExtrema(X, Y, I, type)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2015/9/22
%
% Finds the contour fitting function (see Eq. 12).

switch type
    case 'min'
        I_ext = min(I);
    case 'max'
        I_ext = max(I);
    otherwise
        error('Extrema type `%s` unknown.\n', type);
end
ind = I == I_ext;
f = fit(X(ind), Y(ind), 'poly3');
X_min = min(X(ind));
X_max = max(X(ind));
xRange = [X_min, X_max];
yExtrema = findExtremaCubic(f, xRange);
switch type
    case 'min'
        yExtrema = min(yExtrema);
    case 'max'
        yExtrema = max(yExtrema);
    otherwise
        error('Extrema type `%s` unknown.\n', type);
end

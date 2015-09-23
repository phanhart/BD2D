function Y = findExtremaCubic(f, xRange)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2015/9/22
%
% Finds the extrema of a cubic function.

X = xRange;
delta = f.p2^2 - 3*f.p1*f.p3;
if delta > 0
    roots = [(-f.p2 + sqrt(delta)) / (3*f.p1) , (-f.p2 - sqrt(delta)) / (3*f.p1)];
    if roots(1) >= min(xRange) && roots(1) <= max(xRange)
        X = [X roots(1)];
    end
    if roots(2) >= min(xRange) && roots(2) <= max(xRange)
        X = [X roots(2)];
    end
elseif delta == 0
    root = -f.p2 / (3*f.p1);
    if root >= min(xRange) && root <= max(xRange)
        X = [X root];
    end
end

Y = feval(f, X);

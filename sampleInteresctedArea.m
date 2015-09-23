function [X, Y] = sampleInteresctedArea(algorithms, data)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2015/9/22
%
% Determines the area on which the integral must be evaluated (see Eq. 11).

% Number of points (in each direction) used to compute the finite sum
% instead of the analytical integral
N = 1000;

extremas = {'min', 'max'};

% Find the four contours of each area (Eq. 11)

XY = cell(2);

f = cell(2,2,2);
yExtrema = cell(2,2);
xRange = cell(2,2,2);
for iAxis=1:2
    for jAlgorithm=1:2
        for kExtremas=1:2
            [f{iAxis,jAlgorithm,kExtremas}, yExtrema{iAxis,jAlgorithm,kExtremas}, xRange{iAxis,jAlgorithm,kExtremas}] = findExtrema(algorithms{jAlgorithm}.(data{iAxis,1}), algorithms{jAlgorithm}.(data{iAxis,2}), algorithms{jAlgorithm}.(data{iAxis,3}), extremas{kExtremas});
        end
    end
    XY{iAxis} = linspace(min(yExtrema{iAxis,:,1}), max(yExtrema{iAxis,:,2}), N);
end

% Compute the intersection of the two domains (Eq. 9)

[XY{1}, XY{2}] = meshgrid(XY{1}, XY{2});
XY{1} = XY{1}(:);
XY{2} = XY{2}(:);

valid = true(length(XY{1}),2);
for iAxis=1:2
    for jAlgorithm=1:2
        for kExtremas=1:2
            bound = feval(f{iAxis,jAlgorithm,kExtremas}, XY{3-iAxis});
            bound(XY{3-iAxis} < min(xRange{iAxis,jAlgorithm,kExtremas})) = feval(f{iAxis,jAlgorithm,kExtremas}, min(xRange{iAxis,jAlgorithm,kExtremas}));
            bound(XY{3-iAxis} > max(xRange{iAxis,jAlgorithm,kExtremas})) = feval(f{iAxis,jAlgorithm,kExtremas}, max(xRange{iAxis,jAlgorithm,kExtremas}));
            switch extremas{kExtremas}
                case 'min'
                    valid(:,jAlgorithm) = valid(:,jAlgorithm) & bound <= XY{iAxis};
                case 'max'
                    valid(:,jAlgorithm) = valid(:,jAlgorithm) & XY{iAxis} <= bound;
            end
        end
    end
end

valid = valid(:,1) & valid(:,2);

X = XY{1}(valid);
Y = XY{2}(valid);

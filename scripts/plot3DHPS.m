%%-------------------------------------------------%
% Author: David Northcote
% Last Updated: 22/01/2019
% Organisation: University of Strathclyde
% Location: Glasgow, Scotland
%

function plot3DHPS( HPS )

[maxRho, maxTheta] = size(HPS);
xSize = 1:(maxRho);
ySize = 1:(maxTheta);
[xx, yy] = meshgrid(ySize, xSize);
figure; mesh(xx, yy, HPS);

end


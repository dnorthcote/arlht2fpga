%%-------------------------------------------------%
% Author: David Northcote
% Last Updated: 22/01/2019
% Organisation: University of Strathclyde
% Location: Glasgow, Scotland
%

%% Get Hough Parameter Space
lambda = 0;
[ Aopt, RBM, RBM_Lambda ] = AR_LHT( Is, Gdir, R, deltaTheta, maxTheta, lambda );
hpsRec = zeros(maxRho*2, maxTheta+deltaTheta);

%% Reconstruct Hough Parameter Space
se = ones(3);
Imerode = imerode(logical(RBM), se);
rbmOpen = int16(imdilate(Imerode, se));
for j = 1:2*maxRho
    for i = 1:K 
        for k = 0:R-1
            hpsRec(j, i + k*(K)) = Aopt(j, i) * rbmOpen(j, i + k*(K));
        end
    end
end

%% Get difference between simulation and software
hpsRecSim = data_out';
diff = double(hpsRecSim) - double(hpsRec);
%plot3DHPS(diff);
%plot3DHPS(hpsRec);
%plot3DHPS(hpsRecSim);

%% Obtain peaks in the simulation and reconstruct lines
% Set threshold
if ~exist('LT', 'var')
    LT = 20;
end
% Initialise Line and Output Image
L = zeros(height, width);
O = Ir;
% Extract Maximums
[hpsMax] = max(hpsRecSim(:));
[rhoY, thetaX] = ind2sub(size(hpsRecSim), find((hpsRecSim >= LT)));
% Reconstruct
L = ReconstructLines(rhoY - maxRho, thetaX - 1, L, 0, 0);
%L = bwmorph(L, 'thicken');

%% Apply to Original Image
for y = 1:height
    for x = 1:width
        if L (y,x) > 0
            O(y,x,3) = 0;
            O(y,x,2) = 0;
            O(y,x,1) = 255;
        end
    end
end
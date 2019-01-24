%%-------------------------------------------------%
% Author: David Northcote
% Last Updated: 22/01/2019
% Organisation: University of Strathclyde
% Location: Glasgow, Scotland
%

%% AR-LHT Preprocessing

% Get grayscale
Iy = double(rgb2gray(Ir));

% Get sobel
Is = zeros(size(Iy));

if ~exist('Thresh', 'var')
    Thresh = 40;
end

sobelGy = [1 2 1; 0 0 0; -1 -2 -1];
sobelGx = [1 0 -1; 2 0 -2; 1 0 -1];

Gx = (imfilter(Iy, sobelGx, 'symmetric'));
Gy = (imfilter(Iy, sobelGy, 'symmetric'));
Gmag = sqrt(double(Gx.^2 + Gy.^2));
Gdir = round(double(rad2deg(atan(Gy./Gx))));

for i = 1:height
    for j = 1:width
        
        % Edge Image
        if Gmag(i,j)*2^(-2) >= Thresh
            Is(i,j) = 1;
        else
            Is(i,j) = 0;
        end
        
        % Correct Orientation
        if Gdir(i,j) < 0
            Gdir(i,j) = Gdir(i,j) + maxTheta + deltaTheta;
        end
        
        if ~Is(i, j)
            Gdir(i, j) = 255;
        end
        
    end
end

% Set InputImage
InputImage = uint8(Gdir);
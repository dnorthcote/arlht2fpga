%%-------------------------------------------------%
% Author: David Northcote
% Last Updated: 22/01/2019
% Organisation: University of Strathclyde
% Location: Glasgow, Scotland
%

% Add the higher level folder temporarily for this session.
addpath([newDir, '\dataset']);

% Set model parameters
height = 512;
width = 512;
minTheta = 0;
deltaTheta = 1;
maxTheta = 179;
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));
R = 4;
K = (maxTheta + deltaTheta)/R;

% Get input to model
I = imread('enoch.bmp');
Ir = imresize(I, [height width]);
InputImage = double(Ir);

% Get Latency
L = 9;
StartL = 13;

% Get Time
f = 145e6;
fps = f/((height)*(width));
T = 1/f;
ts = (height*width+L+StartL)*T;
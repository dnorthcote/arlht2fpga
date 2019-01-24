%%-------------------------------------------------%
% Author: David Northcote
% Last Updated: 22/01/2019
% Organisation: University of Strathclyde
% Location: Glasgow, Scotland
%

% The ar_lht_hw model will be ran twice for two candidate images. These are
% enoch.bmp and bars.bmp contained in the /dataset folder. Each image
% requires separate Line and Sobel Threshold parameters. These
% are set prior to running the AR-LHT simulation. The first image to be
% processed is enoch.bmp. This image is the default for running the
% ar_lht_hw simulation. The required threshold values are set during the
% preprocessing step and postprocessing step.

%% Run Simulation (Image 1)
% The model is opened and contains a preload function in its
% callback properties that defines where to find other dependant scripts
% and datasets in the arlht2fpga repository.
open ar_lht_hw;

% Next, the model is configured with a set of system parameters. These
% include the candidate image height and width, the system sample rate and operating
% frequency, and the AR-LHT constraints.
setup;

% Before simulation, the candidate image is preprocessed using a sobel
% filter to extract the image edge response and gradient orientation. These
% are later used by the AR-LHT simulation.
pre_processing;

% The set_param command is used to update/compile the system.
set_param('ar_lht_hw', 'SimulationCommand', 'update')

% The simulation is ran for two frames of the candidate image. Two frames
% are necessary as the system does not contain a double buffer.
set_param('ar_lht_hw', 'SimulationCommand', 'start');

% Wait for simulation end
while(get_param('ar_lht_hw','SimulationStatus') == 'running')
    pause(0.1);
end

%% Stop Simulation (Image 1)
% After simulation the data needs to be prepared so that it can be compared
% to a software model for validation. The following script carries out a
% transpose to the Hough Parameter Space simulation data so that it is in
% the correct format for comparing to the software model. The AR-LHT is the
% implemented in a function using the original candidate image edge and
% gradient orientation data used by the simulation. The results are
% compared by subtracting the difference between each Hough Parameter
% Space array. Additionally, the line data is extracted from the simulation
% parameter space and is reconstructed and applied to the original image.
post_processing;
imtool(O);

%% Run Simulation (Image 2)
% The next image is now simulated using the ar_lht_hw model. The following
% lines change the image to be simulated and updates the required Line and
% Sobel Threshold values. The simulation will then run.
Thresh = 35;
LT = 19;
I = imread('bars.bmp');
setup;
pre_processing;
set_param('ar_lht_hw', 'SimulationCommand', 'update');
set_param('ar_lht_hw', 'SimulationCommand', 'start');
while(get_param('ar_lht_hw','SimulationStatus') == 'running')
    pause(0.1);
end

%% Stop Simulation (Image 2)
% The simulation data is processed and output to imtool.
post_processing;
imtool(O);

%% Clear Workspace
clear;
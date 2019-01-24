%%-------------------------------------------------%
% Author: David Northcote
% Last Updated: 22/01/2019
% Organisation: University of Strathclyde
% Location: Glasgow, Scotland
%

function [ Aopt, RBM, RBM_Lambda ] = AR_LHT( BW, Gdir, R, dTheta, maxTheta, lambda )

%% Get Dimensions
[height, width] = size(BW);

%% Initialise HPS
maxRho = ceil(sqrt((height/2)^2+(width/2)^2));
hps = int16(zeros(maxRho*2, (maxTheta+dTheta)/R));

%% Initialise the RBM
rbm = int16(zeros(maxRho*2, maxTheta+1));
rbm_lambda = int16(zeros(maxRho*2, maxTheta+1));

%% Get Hough Parameter Space and RBM
for y = 1:height
    for x = 1:width
        
        if BW(y,x) > 0
            
            % Adjust Cartesian Positions
            xTemp = x-width/2-1;
            yTemp = y-height/2-1;
            
            % Get Rho and Theta
            theta = Gdir(y,x);
            
            for thetaTemp = theta-lambda*dTheta:dTheta:theta+lambda*dTheta
                
                % Check thetaTemp
                theta_i = thetaTemp;
                if thetaTemp < 0
                    theta_i = thetaTemp + maxTheta + dTheta;
                end
                if thetaTemp > maxTheta
                    theta_i = thetaTemp - maxTheta;
                end
                        
                % Get Hough Parameters
                rho = round(xTemp*cos(deg2rad(theta_i)) + yTemp*sin(deg2rad(theta_i))) + maxRho;
            
                % Get Adjusted Theta
                adjustment = floor(theta_i/((maxTheta + dTheta)/R));
                thetaA = theta_i - adjustment*(maxTheta + dTheta)/R;

                % Apply Vote to HPS
                hps(uint16(rho), uint8(thetaA+1)) = hps(uint16(rho), uint8(thetaA+1)) + 1;
                
                % Get RBM Lambda
                rbm_lambda(uint16(rho), uint8(theta_i + 1)) = 1;
                
            end
            
            % Apply Vote to RBM
            rbm(uint16(rho), uint8(theta+1)) = 1;
            
        end
    end
end

Aopt = hps;
RBM = rbm;
RBM_Lambda = rbm_lambda;

end


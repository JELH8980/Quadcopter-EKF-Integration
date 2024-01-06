% Arguments
% muBar - predicted mean value at time (12x1)
% K - Kalman Gain at time t (12x9)
% zBar - Predicted Measurement (9x1)
% z - Measurement (9x1)

% Output
% mu - Estimated mean value at time t (12x1)
    
function mu = updateKF(muBar, K, zBar, z)

eta = z - zBar;
mu = muBar + K*eta;

end
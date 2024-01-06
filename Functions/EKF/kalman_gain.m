% Arguments:
% SigmaBar - Predicted State Covariance Matrix at time t (12x12)
% H - Jacobian for the measurment model (9x9)

% Outputs:
% K - Kalman Gain at time t (12x9)
% Sigma - Estimated State Covariance at time t (12x12)

function [K, Sigma] = kalman_gain(SigmaBar, H, Q)

K = SigmaBar*H'*inv(H*SigmaBar*H' + Q);
Sigma = (eye(12,12) - K*H)*SigmaBar;
end
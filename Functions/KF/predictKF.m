% Arguments:
% mu - estimated mean value at time t-1 (12x1)
% input - torque input vector (4x1)
% Sigma - Estimated State Covariance Matrix at time t-1 (12x12)
% h - time step (1x1)
% world - object of WORLD class
% drone - object of DRONE class
% filter - object of FILTER class

% Outputs:
% muBar - predicted mean value at time t (12x1)
% SigmaBar - predicted state covariance matrix

function [muBar, SigmaBar] = predictKF(mu, input, Sigma, g, m, I, R, fs)

Ix = I(1,1); Iy = I(2,2); Iz = I(3,3); h = 1/fs;

A = [       1,          0, 0,         h,          0, 0, 0, 0, 0, 0, 0, 0;
            0,          1, 0,         0,          h, 0, 0, 0, 0, 0, 0, 0;
            0,          0, 1,         0,          0, h, 0, 0, 0, 0, 0, 0;
            0,          0, 0,         1,          0, 0, 0, 0, 0, 0, 0, 0;
            0,          0, 0,         0,          1, 0, 0, 0, 0, 0, 0, 0;
            0,          0, 0,         0,          0, 1, 0, 0, 0, 0, 0, 0;
            0,       -g*h, 0,         0, -(g*h^2)/2, 0, 1, 0, 0, 0, 0, 0;
          g*h,          0, 0, (g*h^2)/2,          0, 0, 0, 1, 0, 0, 0, 0;
            0,          0, 0,         0,          0, 0, 0, 0, 1, 0, 0, 0;
            0, -(g*h^2)/2, 0,         0, -(g*h^3)/6, 0, h, 0, 0, 1, 0, 0;
    (g*h^2)/2,          0, 0, (g*h^3)/6,          0, 0, 0, h, 0, 0, 1, 0;
            0,          0, 0,         0,          0, 0, 0, 0, h, 0, 0, 1];

B = [   0,    0,    0,    0;
   0,    0,    0,    0;
   0,    0,    0,    0;
   0, 1/Ix,    0,    0;
   0,    0, 1/Iy,    0;
   0,    0,    0, 1/Iz;
   0,    0,    0,    0;
   0,    0,    0,    0;
-1/m,    0,    0,    0;
   0,    0,    0,    0;
   0,    0,    0,    0;
   0,    0,    0,    0];

muBar = A*mu + B*input;
SigmaBar = A*Sigma*A' + R;

end
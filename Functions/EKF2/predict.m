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

function [muBar, SigmaBar] = predict(mu, input, Sigma, g, m, I, R, fs)

Ix = I(1,1); Iy = I(2,2); Iz = I(3,3); h = 1/fs;

% Unpack State vector
Phi = mu(1); Theta = mu(2); Psi = mu(3);
p = mu(4); q = mu(5); r = mu(6);
u = mu(7); v = mu(8); w = mu(9);


% Unpack Control Vector
ft = input(1); Tx = input(2); Ty = input(3); Tz = input(4);

G = [
    h*(q*cos(Phi)*tan(Theta) + r*sin(Phi)*tan(Theta)) + 1, -h*(r*cos(Phi)*(tan(Theta)^2 + 1) - q*sin(Phi)*(tan(Theta)^2 + 1)), 0, h, h*sin(Phi)*tan(Theta), -h*cos(Phi)*tan(Theta), 0, 0, 0, 0, 0, 0; 
    h*(r*cos(Phi) - q*sin(Phi)), 1, 0, 0, h*cos(Phi), h*sin(Phi), 0, 0, 0, 0, 0, 0;
    -h*((q*cos(Phi))/cos(Theta) + (r*sin(Phi))/cos(Theta)), h*((r*cos(Phi)*sin(Theta))/cos(Theta)^2 - (q*sin(Phi)*sin(Theta))/cos(Theta)^2), 1, 0, -(h*sin(Phi))/cos(Theta), (h*cos(Phi))/cos(Theta), 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, (h*r*(Iy - Iz))/Ix, (h*q*(Iy - Iz))/Ix, 0, 0, 0, 0, 0, 0;
    0, 0, 0, -(h*r*(Ix - Iz))/Iy, 1, -(h*p*(Ix - Iz))/Iy, 0, 0, 0, 0, 0, 0;
    0, 0, 0, (h*q*(Ix - Iy))/Iz, (h*p*(Ix - Iy))/Iz, 1, 0, 0, 0, 0, 0, 0;
    0, -g*h*cos(Theta), 0, 0, -h*w, h*v, 1, h*r, -h*q, 0, 0, 0;
    g*h*cos(Phi)*cos(Theta), -g*h*sin(Phi)*sin(Theta), 0, h*w, 0, -h*u, -h*r, 1, h*p, 0, 0, 0;
    -g*h*cos(Theta)*sin(Phi), -g*h*cos(Phi)*sin(Theta), 0, -h*v, h*u, 0, h*q, -h*p, 1, 0, 0, 0;
    h*(v*(sin(Phi)*sin(Psi) + cos(Phi)*cos(Psi)*sin(Theta)) + w*(cos(Phi)*sin(Psi) - cos(Psi)*sin(Phi)*sin(Theta))), h*(v*cos(Psi)*cos(Theta)*sin(Phi) - u*cos(Psi)*sin(Theta) + w*cos(Phi)*cos(Psi)*cos(Theta)), -h*(v*(cos(Phi)*cos(Psi) + sin(Phi)*sin(Psi)*sin(Theta)) - w*(cos(Psi)*sin(Phi) - cos(Phi)*sin(Psi)*sin(Theta)) + u*cos(Theta)*sin(Psi)), 0, 0, 0, h*cos(Psi)*cos(Theta), -h*(cos(Phi)*sin(Psi) - cos(Psi)*sin(Phi)*sin(Theta)), -h*(cos(Phi)*sin(Psi) - cos(Psi)*sin(Phi)*sin(Theta)), 1, 0, 0;
    -h*(v*(cos(Psi)*sin(Phi) - cos(Phi)*sin(Psi)*sin(Theta)) + w*(cos(Phi)*cos(Psi) + sin(Phi)*sin(Psi)*sin(Theta))), h*(w*cos(Phi)*cos(Theta)*sin(Psi) - u*sin(Psi)*sin(Theta) + v*cos(Theta)*sin(Phi)*sin(Psi)), h*(w*(sin(Phi)*sin(Psi) + cos(Phi)*cos(Psi)*sin(Theta)) - v*(cos(Phi)*sin(Psi) - cos(Psi)*sin(Phi)*sin(Theta)) + u*cos(Psi)*cos(Theta)), 0, 0, 0, h*cos(Theta)*sin(Psi), h*(cos(Phi)*cos(Psi) + sin(Phi)*sin(Psi)*sin(Theta)), -h*(cos(Psi)*sin(Phi) - cos(Phi)*sin(Psi)*sin(Theta)), 0, 1, 0;   
     h*(v*cos(Phi)*cos(Theta) - w*cos(Theta)*sin(Phi)), -h*(u*cos(Theta) + w*cos(Phi)*sin(Theta) + v*sin(Phi)*sin(Theta)), 0, 0, 0, 0, -h*sin(Theta), h*cos(Theta)*sin(Phi), h*cos(Phi)*cos(Theta), 0, 0, 1;
    ];

f = [
 p + q*tan(Theta)*sin(Phi) - r*cos(Phi)*sin(Theta);
 q*cos(Phi) + r*sin(Phi);
  - q*sin(Phi)/cos(Theta) + r*cos(Phi)/cos(Theta);
 q*r*(Iy - Iz)/Ix + Tx/Ix;
 p*r*(Iz - Ix)/Iy + Ty/Iy;
 p*q*(Ix - Iy)/Iz + Tz/Iz;
 r*v - q*w - g*sin(Theta);
 p*w - r*u + g*sin(Phi)*cos(Theta);
 q*u - p*v + g*cos(Theta)*cos(Phi) - ft/m;
 u*(cos(Theta)*cos(Psi)) + v*(cos(Psi)*sin(Phi)*sin(Theta) - cos(Phi)*sin(Psi)) + w*(cos(Phi)*cos(Psi)*sin(Theta) + sin(Phi)*sin(Psi));
 u*(cos(Theta)*sin(Psi)) + v*(sin(Phi)*sin(Psi)*sin(Theta) + cos(Phi)*cos(Psi)) + w*(cos(Phi)*sin(Psi)*sin(Theta) - cos(Psi)*sin(Phi));
 -u*(sin(Theta)) + v*(cos(Theta)*sin(Phi)) + w*(cos(Phi)*cos(Theta))
 ];

muBar = mu + h*f;

SigmaBar = G*Sigma*G' + R;

end
% Arguments
% muBar - Predicted State at time t

% Outputs
% zBar - Predicted Measurement at time t
% H - Jacobian for Measurement Model evaluated for muBar (9x9)

function [zBar, H] = predict_measurement(world, muBar)

Tb = world(1); hb = world(2); Lb = world(3); g = world(4); M = world(5); R = world(6); Pb = world(7);

zBar = zeros(12,1);
zBar(1:9,1) =  muBar(1:9,1);
zBar(10:11,1) = muBar(10:11,1);
zBar(12,1) = Pb * ( (Tb-(-muBar(12)+hb)*Lb) / Tb ) .^ (g*M/(R*Lb));



H = zeros(12,12);
H(1,1)=1; H(2,2)=1; H(3,3)=1; H(4,4)=1; H(5,5)=1; H(6,6)=1; H(7,7) = 1; H(8,8) = 1;
H(9,9) = 1; H(10,10) = 1; H(11,11) = 1; H(12,12) = (M*Pb*g*((Tb - Lb*(hb - muBar(12,1)))/Tb)^((M*g)/(Lb*R) - 1))/(R*Tb);


end
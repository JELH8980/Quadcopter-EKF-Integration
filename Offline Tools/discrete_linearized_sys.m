clear, clc, close all

syms Phi Theta Psi p q r u v w x y z h Ix Iy Iz Tx Ty Tz g ft m Pb hb Kb Tb M R Lb

X = [Phi; Theta; Psi; p; q; r; u; v; w; x; y; z];
input = [ft; Tx; Ty; Tz];

f = [
 p + q*tan(Theta)*sin(Phi) - r*tan(Theta)*cos(Phi);
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

g_func = X + h*f;

for j = 1:12
    for i = 1:12
        G(j,i) = diff(g_func(j), X(i));
    end
end

for j = 1:12
    for i = 1:12
        A_diff(j,i) = diff(f(j), X(i));
    end
end

for j = 1:12
    for i = 1:4
        B_diff(j,i) = diff(f(j), input(i));
    end
end

x_test = [0,0,Psi,0,0,0,0,0,0,0,0,0]';
u_test = [0;0;0;0];

A = subs(A_diff,X,x_test);
B = subs(B_diff,input,u_test);

f = A*X + B*input;

P = Pb * ( (Tb-(-(z-hb))*Lb) / Tb ) ^ (g*M/(R*Lb));

H = sym(zeros(9,12));  % Create a symbolic matrix
H(1,1)=1; H(2,2)=1; H(3,3)=1; H(4,4)=1; H(5,5)=1; H(6,6)=1; H(7,10) = 1; H(8,11) = 1; 
H_diff = diff(P,z);
H(9,12) = subs(H_diff,z,0);

A_d = expm(A*h);
B_d = int(A_d,h)*B;

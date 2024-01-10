% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

function actuator_mat = act_mat(Drone)
b = Drone.b;
r = Drone.r;
d = Drone.d;

actuator_mat = inv([b          ,  b          ,   b          ,   b          ; ...
                    b*r/sqrt(2), -b*r/sqrt(2), - b*r/sqrt(2),   b*r/sqrt(2); ...
                    b*r/sqrt(2),  b*r/sqrt(2), - b*r/sqrt(2), - b*r/sqrt(2); ...
                   -d          ,            d,           - d,             d]);
end
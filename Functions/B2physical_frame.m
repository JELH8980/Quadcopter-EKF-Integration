% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

function   [a1, a2] = B2physical_frame(FrameB)
    R = [cos(pi/4), -sin(pi/4), 0;
         sin(pi/4),  cos(pi/4), 0;
         0        ,  0        , 1];

    a1 = FrameBR'[1;0;0];

    a2 = FrameBR[1;0;0];

end

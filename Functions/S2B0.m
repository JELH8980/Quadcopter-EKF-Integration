% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

function wptB0 = S2B0(wptS, invert)
    R = [1, 0      , 0       ; 
         0, cos(pi), -sin(pi); 
         0, sin(pi), cos(pi)];

    if invert
        wptB0 = R'*wptS;
    else
        wptB0 = R*wptS;
    end

end
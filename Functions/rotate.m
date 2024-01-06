function R = rotate(axis, angle, direction)

angle = rad2deg(angle);
    
% Adjusting for direction of rotation
    if strcmp(direction,'CCW')
        angle = angle;
    else 
        angle = -angle;
    end
    

    if strcmp(axis, '1')
        
        R = rotx(angle);
    
    elseif strcmp(axis, '2')
    
        R = roty(angle);
    
    
    elseif strcmp(axis, '3')
    
        R = rotz(angle);

    end
    

end

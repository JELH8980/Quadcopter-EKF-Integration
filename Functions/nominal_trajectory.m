% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

function varargout = nominal_trajectory(choice, t_end, imu)


% Initializing choice variables------------------------->
directional = false; sequential = false;


% Initializing choice variables-------------------------<
mission = false;

t_vec = 0:1/imu.f:t_end;

if choice == 0 % Mission
    mission_planner()
    input(' ')
    if exist('missionwaypoints.mat', 'file')
         disp('Picture File exists')
         load('missionwaypoints.mat');        
    end

    choice = 3;   
    mission = true;

end

if choice == 1     % Hover
    x_step = 0; y_step = 0; z_step = 10;
    wpts = [x_step, y_step, z_step]';
    tpts = t_end;
    resultS.Trajectory = repmat(wpts, 1, numel(t_vec));
    resultB0.Trajectory = S2B0(resultS.Trajectory, false);
    YAWref = zeros(1,numel(t_vec));

    traj_name = [num2str(t_end), 'Hover', num2str(x_step), num2str(y_step), num2str(z_step)];


elseif choice == 2      % Straight

    yawRefQA = input('Interested in sequential yaw control? (1=YES): ', 's');
    
    if strcmp(yawRefQA, '1')
        sequential = true;
    end

    x_step = 100;
    y_step = 10;
    z_step = 30;

    wpts = [0, 0, 0; x_step, y_step, z_step]';
    tpts = (0:t_end/(length(wpts(1,:))-1):t_end);

    traj_name = [num2str(t_end), 'Straight', num2str(x_step), num2str(y_step), num2str(z_step)];


elseif choice == 3      % Box

    yawRefQA = input('Interested in sequential yaw control? (1=YES): ', 's');
    
    if strcmp(yawRefQA, '1')
        sequential = true;
    end
    
    if ~mission
        x_step = 100; y_step = -100; z_step = 100;
        gnd_clearance = 10;
        wpts = [0,           0, gnd_clearance;
                0,      y_step, gnd_clearance; 
                x_step, y_step, gnd_clearance; 
                x_step, y_step,        z_step;
                x_step,      0,        z_step;
                0,           0,        z_step;
                0,           0, gnd_clearance;]';
    
        tpts = linspace(0, t_end, size(wpts,2));
        traj_name = [num2str(t_end), 'Box', num2str(x_step), num2str(y_step), num2str(z_step)];

    else
        tpts = linspace(0,t_end,size(wpts,2));
        missionName = input('Provide name of mission: ', 's');
        traj_name = [num2str(t_end), 'Mission at', missionName];
    end

elseif choice == 4      % Ellipse

    yawRefQA = input('Interested in directional yaw control? (1=YES): ', 's');
    
    if strcmp(yawRefQA, '1')
        directional = true;

    end


    aa=10; bb=10; alt= 10;     % Axis of symmetry and altitude.
        
    nr_of_rot = 1;
    res = 10;

    wpts = [aa*(cos(0:2*pi/res:nr_of_rot*2*pi)-1); bb*sin(0:2*pi/res:nr_of_rot*2*pi); alt*ones(1, length(0:2*pi/res:nr_of_rot*2*pi))];

    tpts = (0:t_end/(length(wpts(1,:))-1):t_end);

    traj_name = [num2str(t_end), 'Ellipse', num2str(x_step), num2str(y_step), num2str(z_step)];

end






if directional

    resultS.Trajectory = cubicpolytraj(wpts, tpts, t_vec);
    resultB0.Trajectory = S2B0(resultS.Trajectory, false);

    R = zeros(3,numel(t_vec));
    R(:,1) = [1; 0; 0];
    R(1:2,2:end) = [resultB0.Trajectory(1,2:end)-resultB0.Trajectory(1,1:end-1); resultB0.Trajectory(2,2:end)-resultS.Trajectory(2,1:end-1)];
    
    YAWref = zeros(1, length(t_vec)); %I denna vektor lagrar vi yaw-vinklar
    
    for i = 1:length(t_vec)-1
        psi = acos( dot(R(:,i+1),R(:,i) ) / ( norm(R(:,i+1)) * norm(R(:,i)) ) ); %Räkna ut yaw vinkel relativt tidigare riktningsvektor
        if ~isreal(psi) || isnan(psi)
            psi = 0;
        end
        
        c_p = cross(R(:,i),R(:,i+1));
    
        if c_p(3) >= 0 %Om drönaren svänger moturs, addera yaw-vinkel, annars subtrahera
            YAWref(i+1) = YAWref(i)+psi;
        else
            YAWref(i+1) = YAWref(i)-psi;
        end
    end


end

if sequential
    dir = zeros(3,size(wpts,2));
    
    heading = [1; 0; 0];

    dir = [heading, (wpts(:,2:end)-wpts(:,1:end-1))./vecnorm((wpts(:,2:end)-wpts(:,1:end-1)))]; % Weird vectors, dont have norm 1
    
    turnRate = 1;

    noTurns = 0;

    psi = 0;    % Initial orientation is always.

    Psi = psi;

    added_time = 0;


    for k = 1:size(dir,2)-1

        index = k + noTurns;
        % fprintf('=========================\n')
        % fprintf('Index at: %d\n', index)
        % fprintf('nr of turns: %d\n', noTurns)
        % fprintf('=========================\n')
        % disp(dir)
        

        if vecnorm(dir(1:2,k) - dir(1:2,k+1)) ~= 0 && (vecnorm(dir(1:2,k+1)) ~= 0)

            % fprintf('Angle calculation------------------------------------------------------\n')

            angle_magnitude = acos( dot(dir(1:3,k+1), heading) / ( vecnorm(dir(1:3,k+1)) * vecnorm(heading) ) );
            
            projection = cross(dir(:,k+1), heading);

            scaling = sign(projection(3));

            if scaling ~= 0
                angle = scaling*angle_magnitude;
            else
                angle = angle_magnitude;

            end

            
            psi = psi + angle;

            turnTime = abs(angle)/turnRate;

            wpts = [wpts(1:3,1:index), wpts(1:3,index), wpts(1:3,index+1:end)];
            
            tpts = [tpts(:,1:index), tpts(index)+turnTime, tpts(index+1:end)+turnTime];
            
            % fprintf('Angle calculation------------------------------------------------------\n')
            % 
            % fprintf('Turning\n')
   
            Psi = [Psi, psi, psi];
            % fprintf('-------------\n')


            noTurns = noTurns + 1;

            added_time = added_time +  turnTime;
            
        else

            % fprintf('Not Turning\n')
            Psi = [Psi, psi];
        end


        heading = [cos(psi); -sin(psi); 0];

    end



    t_vec = 0:1/imu.f:t_end+added_time;


    resultS.Trajectory = cubicpolytraj(wpts, tpts, t_vec);
    resultB0.Trajectory = S2B0(resultS.Trajectory, false);


    YAWref = cubicpolytraj(Psi, tpts, t_vec);
    
end


if ~directional && ~sequential

    if choice ~= 1 
        resultS.Trajectory = cubicpolytraj(wpts, tpts, t_vec);
        resultB0.Trajectory = S2B0(resultS.Trajectory, false);
    end



    YAWref = zeros(1,size(resultS.Trajectory,2));



end



% Packaging the output----------------------------------------->
resultB0.Trajectory = [resultB0.Trajectory; YAWref];

resultB0.Time.vec = t_vec;
resultB0.Time.end = t_end;
resultS.Time.vec = t_vec;
resultS.Time.end = t_end;

varargout{1} = resultB0;
varargout{2} = resultS;
varargout{3}.wpts = wpts;
varargout{3}.tpts = tpts;
varargout{3}.traj_name = traj_name;
% Packaging the output-----------------------------------------<

end
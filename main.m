clear all; close all; clc
% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

finished = false;


while ~finished
    %% Initialization
    input('If any changes are made to design parameters, make them before you press Enter: ')
    initialize();
    
    %% Trajectory Generation
 
    t_end = input('Provide duration of simulation [sec]: ');
    
    [TrajectoryB0, TrajectoryS, wpts] = nominal_trajectory(0, t_end, imu);
    
    if exist(append(pwd,'\missionwaypoints.mat'), 'file') == 2
        delete(append(pwd,'\missionwaypoints.mat'));
    end
    
    %% Form reference
    N = size(TrajectoryB0.Trajectory, 2);
    
    Xref = [TrajectoryB0.Time.vec', TrajectoryB0.Trajectory(1,:)'];
    Yref = [TrajectoryB0.Time.vec', TrajectoryB0.Trajectory(2,:)'];
    Zref = [TrajectoryB0.Time.vec', TrajectoryB0.Trajectory(3,:)'];
    YAWref = [TrajectoryB0.Time.vec', TrajectoryB0.Trajectory(4,:)'];
    
    figure()
    subplot(2,1,1)
    plot(TrajectoryB0.Time.vec', TrajectoryB0.Trajectory(1:3,:))
    xlabel('time [s]')
    ylabel('[m]')
    legend('X', 'Y', 'Z')
    grid on
    
    subplot(2,1,2)
    plot(TrajectoryB0.Time.vec', TrajectoryB0.Trajectory(4,:)')
    xlabel('time [s]')
    ylabel('[rad]')
    grid on
    
    satisfiedQA = input('Satisfied with the settings (1=YES): ','s');
    
    if strcmp(satisfiedQA, '1')
        satisfied = true;
    end
    
    %% Simulate
    out = sim("SimulationEnv.slx", TrajectoryB0.Time.end);
    
    %% Flight animation
    
    flightAnimationQA = input('Flight animation? (1= YES): ','s');
        
    if strcmp(flightAnimationQA, '1')
       animate_flight(out, drone, TrajectoryS);
    end
    
    %% Evaluate configuration
    evalConfigQA = input('Evaluate Configuration? (1= YES): ','s');
    
    if strcmp(evalConfigQA,'1')
        evaluate_configuration(out, wpts);
    end
    
    
    %% Remove temporary file in case of not saved
    if exist(append(pwd,'\tempMovieSpace.avi'), 'file') == 2
        delete(append(pwd,'\tempMovieSpace.avi'));
    end
    

    finishedQA = input('Do you wish to re-run the software (1=YES)?: ', 's');

    if ~strcmp(finishedQA, '1')
        finished = true;

    else
        finished = false;
    end

end
% Will be able to animate flight, old code, just want to reformat it a bit
function animate_flight(varargin)
    out = varargin{1};
    drone = varargin{2};
    TrajectoryS = varargin{3};

    perspectiveQA = string(input('TPV (1) or From distance (2): '));
    
    if strcmp(perspectiveQA, '1')
    
        SPointMarkerSize = 4;
        SPointLineWidth = 4;
        DroneThickness = 4;
        ampFact = 1;
        
    
    elseif strcmp(perspectiveQA, '2')
    
        SPointMarkerSize = 1;
        SPointLineWidth = 1;
        DroneThickness = 4;
        ampFact = 15;
    
    end
    
    framedelay = 1;
    
    saveAnimationQA = input('Save animation? (1= YES): ','s');
    
    step = 5;
    
    if strcmp(saveAnimationQA,'1')
        
        interestedWatchingQA = input('Interested watching? (1= YES): ','s');
        
        if strcmp( interestedWatchingQA, '1')
            framedelay = 1;
    
        else
            framedelay = 1/1000;
            step = 15;
        end
    
        videoFile = 'tempMovieSpace.avi';
        vidObj = VideoWriter(videoFile, 'Motion JPEG AVI');
        vidObj.Quality = 100; % Adjust quality as needed
        open(vidObj);
    
    
    end
    


    % Acquiring data from simulation----------->
    
    resultOutput = out.state;
    resultEstimate = out.estimated_state;
    resultPropSpeed = out.PropSpeed.Data;
    resultTime = out.tout;
    resultBodyframe = out.R_B2B0;
    resultPosSam = out.PosSamples;
    
    % Acquiring data from simulation-----------<
    
    
    % Formatting data and defining variables--->
    
    
    posB0 = resultOutput.Data(:,10:12);
    estimateB0 = resultEstimate.Data(:,10:12);
    posS = S2B0(posB0', true);
    estimatedS = S2B0(estimateB0', true);
    
    
    % Formatting data and defining variables---<
    

    % Trajectory of reference --------------------->
    Xref = TrajectoryS.Trajectory(1,:)';
    Yref = TrajectoryS.Trajectory(2,:)';
    Zref = TrajectoryS.Trajectory(3,:)';
    % Trajectory of reference ---------------------<
    
        
    % Setting visual properties---------------->

    spaceOverView = 10;

    figureSize = [100, 100, 1200, 800]; % [left, bottom, width, height]
    fig = figure('Position', figureSize);
    set(fig, 'Resize', 'off');
    
     
    xlimits = [min(estimatedS(1,:))-spaceOverView, +max(estimatedS(1,:))+spaceOverView];
    ylimits = [min(estimatedS(2,:))-spaceOverView, +max(estimatedS(2,:))+spaceOverView];
    res = 0.5;    % Resolution of surface points on terrain.
    xgrid = (xlimits(1):res:xlimits(2));
    ygrid = (ylimits(1):res:ylimits(2));

    surf(xgrid, ygrid, zeros(numel(ygrid), numel(xgrid)), 'EdgeColor','none')
    colormap('summer')
   

    axis equal;
    grid on
    
    xlabel('X [m]')
    ylabel('Y [m]')
    zlabel('Z [m]')
    
    hold on

    
    plot3(Xref, Yref, Zref, 'color', 'k','LineStyle', ':', 'LineWidth', 1)
    

    % Setting visual properties----------------<
    
    
    plot3(posS(1,:), posS(2,:), posS(3,:), 'color', 'k')


    estimatedTrajectory = animatedline('Color', 'g');

    
    view(45,45)
    xlim([min(estimatedS(1,:))-spaceOverView, +max(estimatedS(1,:))+spaceOverView]); % Set x-axis limits
    ylim([min(estimatedS(2,:))-spaceOverView, +max(estimatedS(2,:))+spaceOverView]); % Set y-axis limits
    zlim([max(0, min(estimatedS(3,:))-spaceOverView), +max(estimatedS(3,:))+spaceOverView]); % Set z-axis limits
    

    spaceTPV = 5;
    
    r_0 = [0,0,0];
    
    R_B02S = [1, 0, 0;
              0,-1, 0;
              0, 0,-1];
    
    FrameS = pagemtimes(R_B02S, resultBodyframe);

    [a1, a2] = B2physical_frame(resultBodyframe(:,:,1));

    n = resultBodyframe(:,3,1);

    force = resultPropSpeed(1,:);

    scale = 0.1;

    l1 = 7.6; l2 = 0.1;



    % Define force vectors
    fvec1 = plot3([posS(1,1)+a1(1)*drone.r posS(1,1)+a1(1)*drone.r+n(1)*scale*exp(force(1)/(10^5)-l1)*log10(force(1)/(10^5)-l2)], ...
                  [posS(2,1)+a1(2)*drone.r posS(2,1)+a1(2)*drone.r+n(2)*scale*exp(force(1)/(10^5)-l1)*log10(force(1)/(10^5)-l2)], ...
                  [posS(3,1)+a1(3)*drone.r posS(3,1)+a1(3)*drone.r+n(3)*scale*exp(force(1)/(10^5)-l1)*log10(force(1)/(10^5)-l2)], 'color', 'r');
    
    fvec2 = plot3([posS(1,1)+a2(1)*drone.r posS(1,1)+a2(1)*drone.r+n(1)*scale*exp(force(2)/(10^5)-l1)*log10(force(2)/(10^5)-l2)], ...
                  [posS(2,1)+a2(2)*drone.r posS(2,1)+a2(2)*drone.r+n(2)*scale*exp(force(2)/(10^5)-l1)*log10(force(2)/(10^5)-l2)], ...
                  [posS(3,1)+a2(3)*drone.r posS(3,1)+a2(3)*drone.r+n(3)*scale*exp(force(2)/(10^5)-l1)*log10(force(2)/(10^5)-l2)], 'color', 'r');
    
    fvec3 = plot3([posS(1,1)-a1(1)*drone.r posS(1,1)-a1(1)*drone.r+n(1)*scale*exp(force(3)/(10^5)-l1)*log10(force(3)/(10^5)-l2)], ...
                  [posS(2,1)-a1(2)*drone.r posS(2,1)-a1(2)*drone.r+n(2)*scale*exp(force(3)/(10^5)-l1)*log10(force(3)/(10^5)-l2)], ...
                  [posS(3,1)-a1(3)*drone.r posS(3,1)-a1(3)*drone.r+n(3)*scale*exp(force(3)/(10^5)-l1)*log10(force(3)/(10^5)-l2)], 'color', 'r');
    
    fvec4 = plot3([posS(1,1)-a2(1)*drone.r posS(1,1)-a2(1)*drone.r+n(1)*exp(force(4)/(10^5)-l1)*log10(force(4)/(10^5)-l2)], ...
                  [posS(2,1)-a2(2)*drone.r posS(2,1)-a2(2)*drone.r+n(2)*exp(force(4)/(10^5)-l1)*log10(force(4)/(10^5)-l2)], ...
                  [posS(3,1)-a2(3)*drone.r posS(3,1)-a2(3)*drone.r+n(3)*exp(force(4)/(10^5)-l1)*log10(force(4)/(10^5)-l2)], 'color', 'r');
    
    % Define body fixed frame-------------------------->
    h1 = plot3([r_0(1) FrameS(1,1,1)], [r_0(2) FrameS(2,1,1)], [r_0(3) FrameS(3,1,1)], 'color', 'k');
    h2 = plot3([r_0(1) FrameS(1,2,1)], [r_0(2) FrameS(2,2,1)], [r_0(3) FrameS(3,2,1)], 'color', 'k');
    h3 = plot3([r_0(1) FrameS(1,3,1)], [r_0(2) FrameS(2,3,1)], [r_0(3) FrameS(3,3,1)], 'color', 'k');
    % Define body fixed frame--------------------------<

    % Define Samples Point----------------------------->

    plot3(resultPosSam.Data(1,1), -resultPosSam.Data(1,2), -resultPosSam.Data(1,3), 'marker', 'o', 'color', 'm', 'MarkerSize', SPointMarkerSize, 'LineWidth', SPointLineWidth); 
    
    % Define Samples Point-----------------------------<



    % Define drone structure--------------------------->
    ax1 = plot3([posS(1,1)-a1(1)*drone.r posS(1,1)+a1(1)*drone.r], ...
                [posS(2,1)-a1(2)*drone.r posS(2,1)+a1(2)*drone.r], ...
                [posS(3,1)-a1(3)*drone.r posS(3,1)+a1(3)*drone.r], 'color', 'k');
    ax2 = plot3([posS(1,1)-a2(1)*drone.r posS(1,1)+a2(1)*drone.r], ...
                [posS(2,1)-a2(2)*drone.r posS(2,1)+a2(2)*drone.r], ...
                [posS(3,1)-a2(3)*drone.r posS(3,1)+a2(3)*drone.r], 'color', 'k');


    speed = out.Speed.Data;


  if strcmp(perspectiveQA, '1')
    
        view(20,20)
        

        xlim([mean(posS(1,1:1+3))-spaceTPV, mean(posS(1,1:1+3))+spaceTPV]); % Set x-axis limits
        ylim([mean(posS(2,1:1+3))-spaceTPV, mean(posS(2,1:1+3))+spaceTPV]); % Set y-axis limits
        zlim([max(0, mean(posS(3,1:1+3))-spaceTPV), mean(posS(3,1:1+3))+spaceTPV]); % Set z-axis limits



    end


    for k = 2:step:length(resultTime)-1
        pausetime = framedelay*(resultTime(k+1)-resultTime(k));

        % Drawing body fixed frame-------------------------->
        set(h1, 'XData', [posS(1,k) posS(1,k)+FrameS(1,1,k)])
        set(h1, 'YData', [posS(2,k) posS(2,k)+FrameS(2,1,k)])
        set(h1, 'ZData', [posS(3,k) posS(3,k)+FrameS(3,1,k)])

        set(h2, 'XData', [posS(1,k) posS(1,k)+FrameS(1,2,k)])
        set(h2, 'YData', [posS(2,k) posS(2,k)+FrameS(2,2,k)])
        set(h2, 'ZData', [posS(3,k) posS(3,k)+FrameS(3,2,k)])

        set(h3, 'XData', [posS(1,k) posS(1,k)+FrameS(1,3,k)])
        set(h3, 'YData', [posS(2,k) posS(2,k)+FrameS(2,3,k)])
        set(h3, 'ZData', [posS(3,k) posS(3,k)+FrameS(3,3,k)])


  
        % Drawing body fixed frame--------------------------<


        % Labels for body fixed frame-----------------------<

        % Display labels------------------------------------>
            
            % Displayed units
           
        if strcmp(perspectiveQA, '1')

                % Speed
                DisplayedUnits = text(posS(1,k)-12, posS(2,k)-4, posS(3,k)+1.5, sprintf(['Speed: %s m/s \n\n\n' ...
                                                                                              'f_1: %s N   \n\n' ...
                                                                                              'f_2: %s N   \n\n' ...
                                                                                              'f_3: %s N   \n\n' ...
                                                                                              'f_4: %s N   \n\n\n' ...
                                                                                              'X: %s m \n\n' ...
                                                                                              'Y: %s m \n\n' ...
                                                                                              'Z: %s m \n\n'], ...
                                                                                              string(speed(k)), ...
                                                                                              string(force(1)*drone.b), ...
                                                                                              string(force(2)*drone.b), ...
                                                                                              string(force(3)*drone.b), ...
                                                                                              string(force(4)*drone.b), ...
                                                                                              string(posS(1,k)), ...
                                                                                              string(posS(2,k)), ...
                                                                                              string(posS(3,k)) ));
                set(DisplayedUnits, 'Interpreter', 'tex')


        end

        % Displayed axis labels for body fixed frame
        if strcmp(perspectiveQA, '1')
            Displayedb1 = text(posS(1,k)+FrameS(1,1,k), posS(2,k)+FrameS(2,1,k), posS(3,k)+FrameS(3,1,k), "b_1");
            Displayedb2 = text(posS(1,k)+FrameS(1,2,k), posS(2,k)+FrameS(2,2,k), posS(3,k)+FrameS(3,2,k), "b_2");
            Displayedb3 = text(posS(1,k)+FrameS(1,3,k), posS(2,k)+FrameS(2,3,k), posS(3,k)+FrameS(3,3,k), "b_3");
            set(Displayedb1, 'Interpreter', 'tex');
            set(Displayedb2, 'Interpreter', 'tex');
            set(Displayedb3, 'Interpreter', 'tex');
        end
            
        [a1, a2] = B2physical_frame(resultBodyframe(:,:,k));

        % Drawing Drone structure--------------------------->

        set(ax1, 'XData', [posS(1,k)-a1(1)*drone.r*ampFact posS(1,k)+a1(1)*drone.r*ampFact], 'LineWidth', DroneThickness)
        set(ax1, 'YData', [posS(2,k)+a1(2)*drone.r*ampFact posS(2,k)-a1(2)*drone.r*ampFact], 'LineWidth', DroneThickness)
        set(ax1, 'ZData', [posS(3,k)+a1(3)*drone.r*ampFact posS(3,k)-a1(3)*drone.r*ampFact], 'LineWidth', DroneThickness)

        set(ax2, 'XData', [posS(1,k)-a2(1)*drone.r*ampFact posS(1,k)+a2(1)*drone.r*ampFact], 'LineWidth', DroneThickness)
        set(ax2, 'YData', [posS(2,k)+a2(2)*drone.r*ampFact posS(2,k)-a2(2)*drone.r*ampFact], 'LineWidth', DroneThickness)
        set(ax2, 'ZData', [posS(3,k)+a2(3)*drone.r*ampFact posS(3,k)-a2(3)*drone.r*ampFact], 'LineWidth', DroneThickness)

        
        % Drawing Drone structure---------------------------<


        % Drawing measurement marker------------------------>

        index = find(resultPosSam.Time(1:end) >= resultTime(k), 1);
        plot3(resultPosSam.Data(index,1), -resultPosSam.Data(index,2), -resultPosSam.Data(index,3), 'marker', 'o', 'color', 'm','MarkerSize', SPointMarkerSize, 'LineWidth', SPointLineWidth); 

        
        % Drawing measurement marker------------------------<


        % Drawing Estimated current point------------------->
        
        addpoints(estimatedTrajectory, estimatedS(1,k), estimatedS(2,k), estimatedS(3,k));
        
        % Drawing Estimated current point-------------------<
        

        % Drawing current marker point---------------------->

        currentEstPoint = plot3(estimatedS(1,k), estimatedS(2,k), estimatedS(3,k), 'Color', 'g', 'Marker', 'o', 'LineWidth', 3);

        % Drawing current marker point----------------------<


        n = resultBodyframe(:,3,k);
        
        if k < size(2:length(resultTime)-1,2) - 4
            force = resultPropSpeed(k,:);
    
            % Drawing force vectors----------------------------->

            set(fvec1, 'XData', [posS(1,k)+a1(1)*drone.r*ampFact posS(1,k)+a1(1)*drone.r*ampFact-n(1)*scale*exp(force(1)/(10^5)-l1)*log10(force(1)/(10^5)-l2)])
            set(fvec1, 'YData', [posS(2,k)-a1(2)*drone.r*ampFact posS(2,k)-a1(2)*drone.r*ampFact+n(2)*scale*exp(force(1)/(10^5)-l1)*log10(force(1)/(10^5)-l2)])
            set(fvec1, 'ZData', [posS(3,k)-a1(3)*drone.r*ampFact posS(3,k)-a1(3)*drone.r*ampFact+n(3)*scale*exp(force(1)/(10^5)-l1)*log10(force(1)/(10^5)-l2)])

            set(fvec2, 'XData', [posS(1,k)+a2(1)*drone.r*ampFact posS(1,k)+a2(1)*drone.r*ampFact-n(1)*scale*exp(force(2)/(10^5)-l1)*log10(force(2)/(10^5)-l2)])
            set(fvec2, 'YData', [posS(2,k)-a2(2)*drone.r*ampFact posS(2,k)-a2(2)*drone.r*ampFact+n(2)*scale*exp(force(2)/(10^5)-l1)*log10(force(2)/(10^5)-l2)])
            set(fvec2, 'ZData', [posS(3,k)-a2(3)*drone.r*ampFact posS(3,k)-a2(3)*drone.r*ampFact+n(3)*scale*exp(force(2)/(10^5)-l1)*log10(force(2)/(10^5)-l2)])

            set(fvec3, 'XData', [posS(1,k)-a1(1)*drone.r*ampFact posS(1,k)-a1(1)*drone.r*ampFact-n(1)*scale*exp(force(3)/(10^5)-l1)*log10(force(3)/(10^5)-l2)])
            set(fvec3, 'YData', [posS(2,k)+a1(2)*drone.r*ampFact posS(2,k)+a1(2)*drone.r*ampFact+n(2)*scale*exp(force(3)/(10^5)-l1)*log10(force(3)/(10^5)-l2)])
            set(fvec3, 'ZData', [posS(3,k)+a1(3)*drone.r*ampFact posS(3,k)+a1(3)*drone.r*ampFact+n(3)*scale*exp(force(3)/(10^5)-l1)*log10(force(3)/(10^5)-l2)])

            set(fvec4, 'XData', [posS(1,k)-a2(1)*drone.r*ampFact posS(1,k)-a2(1)*drone.r*ampFact-n(1)*scale*exp(force(4)/(10^5)-l1)*log10(force(4)/(10^5)-l2)])
            set(fvec4, 'YData', [posS(2,k)+a2(2)*drone.r*ampFact posS(2,k)+a2(2)*drone.r*ampFact+n(2)*scale*exp(force(4)/(10^5)-l1)*log10(force(4)/(10^5)-l2)])
            set(fvec4, 'ZData', [posS(3,k)+a2(3)*drone.r*ampFact posS(3,k)+a2(3)*drone.r*ampFact+n(3)*scale*exp(force(4)/(10^5)-l1)*log10(force(4)/(10^5)-l2)])
        end

            % Take z axis, mirror it and shift to edges of arms and scale
            % its magnitude with abs(omega)
            
        % Drawing force vectors-----------------------------<
            

        drawnow

        pause(pausetime)
        % Setting visual properties----------------<


        % If Animation is saved=-=-=-=-=-=-=-=-=-=-=-=-=-=>
        if strcmp(saveAnimationQA,'1')
            frame = getframe(gcf);
            writeVideo(vidObj, frame);
        end
        % If Animation is saved=-=-=-=-=-=-=-=-=-=-=-=-=-=<
        

        if strcmp(perspectiveQA, '1')
        
            view(20,20)
            
            if k < size(2:length(resultTime)-1,2) - 4
                xlim([mean(posS(1,k:k+3))-spaceTPV, mean(posS(1,k:k+3))+spaceTPV]); % Set x-axis limits
                ylim([mean(posS(2,k:k+3))-spaceTPV, mean(posS(2,k:k+3))+spaceTPV]); % Set y-axis limits
                zlim([max(0, mean(posS(3,k:k+3))-spaceTPV), mean(posS(3,k:k+3))+spaceTPV]); % Set z-axis limits

            end

           
        delete(DisplayedUnits)
        delete(Displayedb1)
        delete(Displayedb2)
        delete(Displayedb3)

        end

        delete(currentEstPoint)

    end

    if strcmp(saveAnimationQA,'1')
        close(vidObj);
    end
   


end
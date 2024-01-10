% Mission Planner for Educational Purposes
%
% This MATLAB script is developed for educational purposes only. The pictures
% used in the 'OverheadPictures' directory are obtained from Google Earth among other sources and
% are intended to demonstrate various capabilities of drones. The usage of
% these pictures are purely educational, and there is no intention for
% commercial or practical applications in relation to the locations displayed.
%
% Author: Ludwig Horvath
% Date: 1/6/2024



function mission_planner()
    addpath(append(pwd, '\OverheadPictures'));

    files = dir(append(pwd, '\OverheadPictures'));
    files = files(~ismember({files.name}, {'.', '..'}));

    pictureFilenames = cell(numel(files), 1);

    fprintf('\n================================================\n')
    fprintf('Choose overhead picture for mission planning (provide Nr:_ )....\n')

    for i = 1:numel(files)
        pictureFilenames{i} = files(i).name;
        fprintf('Filename: %s . (Nr %d)\n', files(i).name, i)
    end

    fprintf('================================================\n')
    fprintf('\n')
    Nr = input('Input Nr of file: ');
    fprintf('\n')

    pictureFile = char(pictureFilenames(Nr));

    % Load background image
    backgroundTemplate = flip(imread(pictureFile));

    nameParts = split(pictureFile, {'X', 'Y', '.'});
    EMax = nameParts{2};
    NMax = nameParts{3};

    Elimits = [0, str2double(EMax)];
    Nlimits = [0, str2double(NMax)];

    ESpan = abs(Elimits(2)-Elimits(1));
    NSpan = abs(Nlimits(2)-Nlimits(1));

    % Initialize figure
    fig = figure('Position', [0, 0, 800, 600]);
    set(fig, 'Resize', 'off');

    ax = axes('Parent', fig, 'XLim', [Elimits(1) Elimits(2)], 'YLim', [Nlimits(1) Nlimits(2)]);
    hold(ax, 'on');
    xlabel('E [m]')
    ylabel('N [m]')

 

    % Load background image
    backgroundHandle = image(ax, 'XData', [Elimits(1) Elimits(2)], 'YData', [Nlimits(1) Nlimits(2)], 'CData', backgroundTemplate);
    uistack(backgroundHandle, 'bottom');

    templateOrigin = [0, 0]; angle = 0;

    mouseAt = [0,0]; scale = [1, 1]; altitude = 0;

    currentState = 'setStartingPose';

    set(gcf, 'WindowButtonMotionFcn', @mouseMoveCallback)


    spaceKeyPressed = false; 
    
    Frame = [1,  0;
             0, -1];

    r = 1;

    a1 = [cos(pi/4), -sin(pi/4);
          sin(pi/4),  cos(pi/4)]  * Frame(:,1);

    a2 = [cos(pi/4), -sin(pi/4);
          sin(pi/4),  cos(pi/4)]' * Frame(:,1);

    ax1 = plot(ax, [templateOrigin(1)-a1(1)*r templateOrigin(1)+a1(1)*r], ...
               [templateOrigin(2)-a1(2)*r templateOrigin(2)+a1(2)*r], 'color', 'k', 'LineWidth', 4);
    ax2 = plot(ax, [templateOrigin(1)-a2(1)*r templateOrigin(1)+a2(1)*r], ...
               [templateOrigin(2)-a2(2)*r templateOrigin(2)+a2(2)*r], 'color', 'k', 'LineWidth', 4);


    horizontal_ax = plot(ax, [mouseAt(1)-1*scale(1)*ESpan, mouseAt(1)+1*scale(1)*ESpan], [mouseAt(2), mouseAt(2)]);
    vertical_ax = plot(ax, [mouseAt(1)  mouseAt(1)], [mouseAt(2)-1*scale(2)*NSpan, mouseAt(2)+1*scale(2)*NSpan]);
 

    b1 = plot(ax, [templateOrigin(1) templateOrigin(1)+Frame(1,1)*scale(1)*ESpan], [templateOrigin(2) templateOrigin(2)+Frame(2,1)*scale(2)*NSpan], 'color', 'g', 'LineWidth', 2);
    b2 = plot(ax, [templateOrigin(1) templateOrigin(1)+Frame(1,2)*scale(1)*ESpan], [templateOrigin(2) templateOrigin(2)+Frame(2,2)*scale(2)*NSpan], 'color', 'g', 'LineWidth', 2);
    
    

    labelb1 = text(templateOrigin(1)+Frame(1,1)*1.3*scale(1)*ESpan, templateOrigin(2)+Frame(2,1)*1.3*scale(2)*NSpan, "b_1", 'Color', 'g');
    labelb2 = text(templateOrigin(1)+Frame(1,2)*1.3*scale(1)*ESpan, templateOrigin(2)+Frame(2,2)*1.3*scale(2)*NSpan, "b_2", 'Color', 'g');


    
    realtimeAltitude = text(mouseAt(1)-0.1*scale(1)*ESpan, mouseAt(2)-0.1*scale(1)*NSpan, sprintf('Z: %s [m]', string(altitude)), 'Interpreter', 'tex', 'Color', 'g');


  newscale = scale;
   

    function mouseMoveCallback(~, ~)
        
        currentPoint = get(gca, 'CurrentPoint');
        mouseAt = [currentPoint(1, 1), currentPoint(1, 2)];
        set(horizontal_ax, 'XData', [mouseAt(1)-1*scale(1)*ESpan,  mouseAt(1)+1*scale(1)*ESpan], ...
                           'YData', [mouseAt(2), mouseAt(2)], ...
                           'LineWidth', 1, 'color', 'g', 'LineStyle', '--');
        set(vertical_ax, 'XData', [mouseAt(1),  mouseAt(1)], ...
                         'YData', [mouseAt(2)-1*scale(2)*NSpan, mouseAt(2)+1*scale(2)*NSpan], ...
                          'LineWidth', 1, 'color', 'g', 'LineStyle', '--');
        
        set(realtimeAltitude, 'Position', [mouseAt(1)-0.1*scale(1)*ESpan, mouseAt(2)-0.1*scale(2)*NSpan]);

        if strcmp(currentState, 'setStartingPose')

            % Update template position
            templateOrigin(1) = currentPoint(1, 1);
            templateOrigin(2) = currentPoint(1, 2);
            set(b1, 'XData', [templateOrigin(1),  templateOrigin(1)+Frame(1,1)*0.1*scale(1)*ESpan], 'YData', [templateOrigin(2), templateOrigin(2)+Frame(1,2)*0.1*scale(2)*NSpan]);
            set(b2, 'XData', [templateOrigin(1),  templateOrigin(1)+Frame(1,2)*0.1*scale(1)*ESpan], 'YData', [templateOrigin(2), templateOrigin(2)+Frame(2,2)*0.1*scale(2)*NSpan]);
            set(ax1, 'XData', [templateOrigin(1)-a1(1)*r,  templateOrigin(1)+a1(1)*r], 'YData', [templateOrigin(2)-a1(2)*r, templateOrigin(2)+a1(2)*r]);
            set(ax2, 'XData', [templateOrigin(1)-a2(1)*r,  templateOrigin(1)+a2(1)*r], 'YData', [templateOrigin(2)-a2(2)*r, templateOrigin(2)+a2(2)*r]);
            set(labelb1, 'Position', [templateOrigin(1)+Frame(1,1)*0.13*scale(1)*ESpan, templateOrigin(2)+Frame(1,2)*0.13*scale(2)*NSpan]);
            set(labelb2, 'Position', [templateOrigin(1)+Frame(1,2)*0.13*scale(1)*ESpan, templateOrigin(2)+Frame(2,2)*0.13*scale(2)*NSpan]);

        end

        switch currentState

            case 'setStartingPose'
                set(fig, 'WindowButtonDownFcn', @mouseButtonDownCallback);
                set(fig, 'WindowKeyPressFcn', @keyPressedCallback);
                set(fig, 'WindowKeyReleaseFcn', @keyReleasedCallback);
                set(fig, 'WindowScrollWheelFcn', @mouseScrollCallback);

            case 'setPath'
                set(fig, 'WindowButtonDownFcn', @mouseButtonDownCallback);
                set(fig, 'WindowKeyPressFcn', @keyPressedCallback);
                set(fig, 'WindowKeyReleaseFcn', @keyReleasedCallback);
                set(fig, 'WindowScrollWheelFcn', @mouseScrollCallback);
            case 'Completion'
                return
        end

    end

    % Initialize variables in the scope of callbacks
    waypoints = [];
    wpts = [];
    startingPoint = zeros(2,1);
    altitude = 0;
    psi0 = 0;

    function mouseButtonDownCallback(~, ~)

        if strcmp(currentState, 'setStartingPose')
            currentState = 'setPath';
            point = get(ax, 'CurrentPoint');
            x = point(1, 1);
            y = point(1, 2);
            startingPoint(1) =  x;
            startingPoint(2) =  y;
            startingPoint(3) =  0;
            waypoints = [waypoints; x, y];
            wpts = [wpts, [0;0;altitude]];
            plot(ax, x, y, 'g.', 'LineWidth', 2);
            plot(ax, [templateOrigin(1) templateOrigin(1)+Frame(1,1)*0.05*scale(1)*ESpan], [templateOrigin(2) templateOrigin(2)+Frame(2,1)*0.05*scale(2)*NSpan], 'color', 'c', 'LineWidth', 3);
            plot(ax, [templateOrigin(1) templateOrigin(1)-Frame(1,2)*0.05*scale(1)*ESpan], [templateOrigin(2) templateOrigin(2)-Frame(2,2)*0.05*scale(2)*NSpan], 'color', 'c', 'LineWidth', 3);
            text(templateOrigin(1)+Frame(1,1)*0.06*scale(1)*ESpan, templateOrigin(2)+Frame(2,1)*0.06*scale(2)*NSpan, "X", 'Color', 'c');
            text(templateOrigin(1)-Frame(1,2)*0.06*scale(1)*ESpan, templateOrigin(2)-Frame(2,2)*0.06*scale(2)*NSpan, "Y", 'Color', 'c');
            psi0 = angle;
                                                                                                                      
        elseif strcmp(currentState, 'setPath')
            % Get the current point clicked
            point = get(ax, 'CurrentPoint');
            
         
            x = point(1, 1);
            y = point(1, 2);
            

            new_wpt = [cosd(psi0),-sind(psi0); 
                       sind(psi0), cosd(psi0)]'*[x-startingPoint(1);y-startingPoint(2)];

            wpts = [wpts, [new_wpt(1); new_wpt(2); altitude]];

            % Add waypoint
            waypoints = [waypoints; x, y];

            % Plot waypoints
            plot(ax, x, y, 'g.-', 'LineWidth', 2);
                                   
            % Connect waypoints with straight lines
            if size(waypoints, 1) > 1
                plot(ax, waypoints(:, 1), waypoints(:, 2), 'g-.', 'LineWidth', 0.2);
                labelAltitude = text(x+1, y+1, sprintf('Z: %s', string(altitude)), 'color', 'g');
                set(labelAltitude, 'Interpreter', 'tex')
            end

        end

    end

    function keyPressedCallback(~, event)
        if strcmp(event.Key, 'space')
            spaceKeyPressed = true;
        end


        if strcmp(event.Key, 'f')

         if strcmp(currentState, 'setStartingPose')
             disp('Lost result, did not receive fully defined mission.')
             disp('Consider restarting the software.')
         end

         if strcmp(currentState, 'setPath')
             % Save waypoints to a file
             save('missionwaypoints.mat', 'wpts');
             disp('Saving waypoints for trajectory generation')
             close(fig)
             fprintf('Press Enter to proceed\n')
             currentState = 'Completion';
             
         end

        end


    end



    function keyReleasedCallback(~, event)
        if strcmp(event.Key, 'space')
            spaceKeyPressed = false;
        end
    end

    function mouseScrollCallback(~, event)
        % Update rotation angle based on mouse wheel scrolling
        if strcmp(currentState, 'setPath')
            set(realtimeAltitude, 'String', sprintf('Z: %s [m]', string(altitude)));
        end
        if spaceKeyPressed

            newscale(1) = abs(scale(1)) + .01*event.VerticalScrollCount;
            newscale(2) = abs(scale(2)) + .01*event.VerticalScrollCount;
            
            xdistr = Elimits(2)-mouseAt(1);
            xdistl = Elimits(2)-xdistr;

            xdistl = xdistl*newscale(1);
            xdistr = xdistr*newscale(1);

            xmaxr = mouseAt(1) + xdistr;

            xmaxl = mouseAt(1) - xdistl;

                            

            ydistr = Nlimits(2)-mouseAt(2);
            ydistl = Nlimits(2)-ydistr;

            ydistl = ydistl*newscale(2);
            ydistr = ydistr*newscale(2);
            

            ymaxr = mouseAt(2) + ydistr;

            ymaxl = mouseAt(2) - ydistl;

            
                             
            newElimits = [xmaxl, xmaxr];  % Specify your new X-axis limits
            newNlimits = [ymaxl, ymaxr];  % Specify your new Y-axis limits
            


            if newscale(1) <= 1
                scale(1)=newscale(1);
                set(ax, 'XLim', newElimits);
                scale(2)=newscale(2);
                set(ax, 'YLim', newNlimits);

            end

        else
            if strcmp(currentState, 'setStartingPose')
                angle_change = 5*event.VerticalScrollCount;

                angle = angle + angle_change;
                
                % Rotate the template and its alpha channel separately
                Frame = [cosd(angle_change), -sind(angle_change); 
                         sind(angle_change), cosd(angle_change)]*Frame;

                % Display the updated template with the rotated angle
                set(b1, 'XData', [templateOrigin(1),  templateOrigin(1)+Frame(1,1)*0.1*scale(1)*ESpan], 'YData', [templateOrigin(2), templateOrigin(2)+Frame(1,2)*0.1*scale(2)*NSpan]);
                set(b2, 'XData', [templateOrigin(1),  templateOrigin(1)+Frame(1,2)*0.1*scale(1)*ESpan], 'YData', [templateOrigin(2), templateOrigin(2)+Frame(2,2)*0.1*scale(2)*NSpan]);
                set(ax1, 'XData', [templateOrigin(1)-a1(1)*r,  templateOrigin(1)+a1(1)*r], 'YData', [templateOrigin(2)-a1(2)*r, templateOrigin(2)+a1(2)*r]);
                set(ax2, 'XData', [templateOrigin(1)-a2(1)*r,  templateOrigin(1)+a2(1)*r], 'YData', [templateOrigin(2)-a2(2)*r, templateOrigin(2)+a2(2)*r]);
                a1 = [cos(pi/4), -sin(pi/4);
                      sin(pi/4),  cos(pi/4)]  * Frame(:,1);
            
                a2 = [cos(pi/4), -sin(pi/4);
                      sin(pi/4),  cos(pi/4)]' * Frame(:,1);
                set(labelb1, 'Position', [templateOrigin(1)+Frame(1,1)*0.13*scale(1)*ESpan, templateOrigin(2)+Frame(1,2)*0.13*scale(2)*NSpan]);
                set(labelb2, 'Position', [templateOrigin(1)+Frame(1,2)*0.13*scale(1)*ESpan, templateOrigin(2)+Frame(2,2)*0.13*scale(2)*NSpan]);
                set(labelb1, 'Interpreter', 'tex');
                set(labelb2, 'Interpreter', 'tex');

            elseif strcmp(currentState, 'setPath')

                altitude = altitude + event.VerticalScrollCount;

            end

  
        end

    end

end

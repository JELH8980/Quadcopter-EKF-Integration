function draw_trajectory()
    % Initialize figure
    fig = figure;
    ax = axes('XLim', [0 50], 'YLim', [0 50]);
    hold(ax, 'on');
    grid(ax, 'on');

    % Set up callbacks
    set(fig, 'WindowButtonDownFcn', @addWaypoint);

    % Initialize waypoints
    waypoints = [];

    function addWaypoint(~, ~)
        % Get current point clicked
        point = get(ax, 'CurrentPoint');
        x = point(1, 1);
        y = point(1, 2);

        % Add waypoint
        waypoints = [waypoints; x, y];

        % Plot waypoints
        plot(ax, x, y, 'ro-', 'LineWidth', 2);

        % Connect waypoints with straight lines
        if size(waypoints, 1) > 1
            plot(ax, waypoints(:, 1), waypoints(:, 2), 'b-', 'LineWidth', 2);
        end
    end
end


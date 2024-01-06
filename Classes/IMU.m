
% Author: Ludwig Horvath, Martin Petré

% Date 12/19/2023

classdef IMU
    properties
        % Operating frequency f
        f (1,1) double {mustBeReal, mustBeFinite} % [Hz]

        % Standard Deviation (Uncertainty) std
        std (3,1) double {mustBeReal, mustBeFinite}
        
        % Add initial declination
        theta_d (1,1) double {mustBeReal, mustBeFinite} % [deg]

        % Initial orientation relative to Inertial frame
        Euler0 (3,1) double {mustBeReal, mustBeFinite} % [rad]
    end

    methods
        function obj = IMU(f, std, theta_d, Euler0)
            obj.f = f;
            obj.std = std;
            obj.theta_d = theta_d;
            obj.Euler0 = Euler0;
        end
    end
end

% Author: Ludwig Horvath, Martin Petré

% Date 12/19/2023

classdef BAROMETER
    properties
        % Operating frequency f
        f (1,1) double {mustBeReal, mustBeFinite} % [Hz]

        % Standard Deviation (Uncertainty) std
        std (1,1) double {mustBeReal, mustBeFinite}
        

        % Add initial declination
    end

    methods
        function obj = BAROMETER(f, std)
            obj.f = f;
            obj.std = std;
            % Add initial declination
        end
    end
end
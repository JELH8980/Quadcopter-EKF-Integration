
% Author: Ludwig Horvath, Martin Petré

% Date 12/19/2023


classdef GPS
    properties
        % Operating frequency f
        f (1,1) int32 {mustBeReal, mustBeFinite} % [Hz]

        % Standard Deviation (Uncertainty) std
        std (3,1) double {mustBeReal, mustBeFinite}
        

    end

    methods
        function obj = GPS(f, std)
            obj.f = f;
            obj.std = std;
        end
    end
end
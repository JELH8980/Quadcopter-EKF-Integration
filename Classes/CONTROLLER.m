
% Author: Ludwig Horvath, Martin Petré

% Date 12/19/2023

classdef CONTROLLER
    properties
        % Type
        type

        % Q
        Q (12, 12) {mustBeReal, mustBeFinite}

        % R
        R (4, 4) {mustBeReal, mustBeFinite}


        % L
        L {mustBeReal, mustBeFinite}


        % 
        S {mustBeReal, mustBeFinite}

    end

    methods
        function obj = CONTROLLER(type, varargin)

            if strcmp(type, 'LQR')  % Use strcmp to compare strings
                obj.type = 'LQR';
                obj.Q = varargin{1};
                obj.R = varargin{2};
                system = varargin{3};
                [obj.L, obj.S] = lqr(system.A, system.B, ...
                obj.Q, obj.R);
                
            else
                error('CONTROLLER:InvalidInput', 'Type must be LQR');
            end

        end
    end
end

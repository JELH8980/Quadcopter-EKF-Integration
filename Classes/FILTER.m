% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

classdef FILTER
    %FILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        R (12, 12) double {mustBeReal, mustBeFinite}
        Q  double {mustBeReal, mustBeFinite}
        Sigma_0 (12,12) double {mustBeReal, mustBeFinite}
        mu_0 (12,1) double {mustBeReal, mustBeFinite}
    end
    
    methods
        function obj = FILTER(R,Q, Sigma_0, mu_0)
            %FILTER Construct an instance of this class
            %   Detailed explanation goes here
            obj.R = R;
            obj.Q = Q;
            obj.Sigma_0 = Sigma_0;
            obj.mu_0 = mu_0;
        end
    end
end


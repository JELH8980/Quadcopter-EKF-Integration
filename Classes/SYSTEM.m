% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

classdef SYSTEM
    %UNTITLED14 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        A (12, 12) double {mustBeReal, mustBeFinite}
        B (12, 4) double {mustBeReal, mustBeFinite}
        C (12, 12) double {mustBeReal, mustBeFinite}
        D (12, 4) double {mustBeReal, mustBeFinite}
        sys

    end

    methods
        function obj = SYSTEM(A, B, C, D)
            %UNTITLED14 Construct an instance of this class
            %   Detailed explanation goes here
            obj.A = A;
            obj.B = B;
            obj.C = C;
            obj.D = D;
            obj.sys = ss(obj.A, obj.B, obj.C, obj.D);
        end
    end
end
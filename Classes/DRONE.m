% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

classdef DRONE
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Physical parameters

        % Inertia
        m (1,1) double {mustBeReal, mustBeFinite}
        I (3,3) double {mustBeReal, mustBeFinite}
        
        % Distance to Actuator
        r (1,1) double {mustBeReal, mustBeFinite}

        % Propellers
        b (1,1) double {mustBeReal, mustBeFinite}   % Lift Coefficient
        d (1,1) double {mustBeReal, mustBeFinite}   % Drag Coefficient
        
        % Electronics
        k_t (1,1) double {mustBeReal, mustBeFinite}  % Motor Kt-Value
        k_v (1,1) double {mustBeReal, mustBeFinite}        % Motor Kv-Value
        Q (1,1) double {mustBeReal, mustBeFinite}     % Battery Nominal Voltage

        % Sensors
        gps 
        imu 
    end
    
    methods
        function obj = DRONE(m, I, r, b, d, k_v, Q, imu, gps)

            obj.m = m;
            obj.I = I;
            obj.r = r;
            obj.b = b;
            obj.d = d;
            obj.k_v = k_v;
            obj.k_t = 1/k_v;
            obj.Q = Q;
            obj.imu = imu;
            obj.gps = gps;
        end
    end
end




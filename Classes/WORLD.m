
% Author: Ludwig Horvath, Martin Petré

% Date 12/19/2023

classdef WORLD
    properties
        % Spheroid Model
        model

        % Gravity constant
        g  {mustBeReal}

        % Point of Reference
        ref (3,1) {mustBeReal}

        % Direction of Reference
        psi_0 (1,1) {mustBeReal}

        % Reference temperature
        Tb (1,1) {mustBeReal}

        % MSL
        hb (1,1) {mustBeReal}

        % Molas Mass Earth Air
        M (1,1) {mustBeReal}

        % Boltzmanns cosntant
        R (1,1) {mustBeReal}

        % Lapse Rate in ISA
        Lb (1,1) {mustBeReal}
        
        % Reference Pressure
        Pb (1,1) {mustBeReal}

        wind_model
    end

    methods
        function obj = WORLD(g, model, ref, psi_0, Tb, hb, M, R, Lb, Pb, wind_model)

            if model == 'WGS84'
                obj.model = referenceEllipsoid('wgs84', 'meters');

            else
                 error('myFunction:InvalidInput', 'Input must be WGS84');
            end
            obj.g = g;
            obj.ref = ref;
            obj.psi_0 = psi_0;
            obj.Tb = Tb;
            obj.hb = hb;
            obj.Lb = Lb;
            obj.M = M;
            obj.R = R;
            obj.Lb = Lb;
            obj.wind_model = wind_model;
            obj.Pb = Pb;
        end
    end
end
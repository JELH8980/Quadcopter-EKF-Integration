clear all; close all; clc

% Author: Ludwig Horvath, Martin Petré

% Date 12/19/2023

% Adding paths

working_directory = pwd;

addpath(append(pwd, '/Simulink'));

addpath(append(pwd, '/Classes'));

addpath(append(pwd, '/Functions'));

addpath(append(pwd, '/Functions/EKF2')); % KF, EKF or EKF2 


addpath(append(pwd, '/System Parameters/EKF2')); %Add EKF2 if EKF2

% Initialize parameters

gps = GPS(2, [0.00001; 0.00001; 1]);

imu = IMU(100, [0.0001, 0.0001, 0.0001], 5, [0,0,0]);

drone = DRONE(0.923, diag([0.006, 0.006, 0.0011]), 0.28, 2.347795774410792e-06, ...
    3.387174887404395e-08, 2650, 1800, imu, gps);

%% Generate FIR coefficients for Air Modelling

[b,a, coeff] = gen_wind_model();

windModel.b = b;
windModel.a = a;
windModel.coeff = coeff;

world = WORLD(9.82, 'WGS84', [59.2816353; 18.1076279; 48], ...
    pi/4, 273, 0, 0.0289644, 8.3144598, 6.3/1000, 1010, windModel);


barometer = BAROMETER(10, 0.01);

act_mat = act_mat(drone);

% Initializing System

[A, B] = linearization(world.g, drone.I, drone.m, 0);

D = 0;
C = eye(12);

system = SYSTEM(A,B,C,D);

%% Initializing Controller 
load CostState % Q
load CostInput % R

BIGL = generate360LQR(Q,R,drone.I,drone.m, world.g);

controller = CONTROLLER('LQR', Q, R, system);

%% Initializing EKF Filter

load MeasNoiseCov.mat %Q_noise
load ProcNoiseCov.mat %R_noise

Sigma_0 = eye(12,12);
mu_0 = zeros(12,1);

filter = FILTER(R_noise, Q_noise, Sigma_0, mu_0);

satisfied = false;



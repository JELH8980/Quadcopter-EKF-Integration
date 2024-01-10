% Author: Ludwig Horvath, Martin Petré

% Date: 12/19/2023

clear all; close all; clc

addpath(append(pwd, '/Functions'));

datespan = {'2024-01-02', '2024-01-04'};

fprintf('\n')
fprintf('===================================================\n')
fprintf('Feel free to adjust the displayed regions before closing down the figure.\n')
fprintf('===================================================\n')
fprintf('\n')
compare_results(datespan);
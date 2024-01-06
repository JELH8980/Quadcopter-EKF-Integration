function [b,a, coeff] = gen_wind_model()
    % Define parameters
    fs = 100; % Sampling frequency
    n = 2;    % Filter order
    w = 10;    % Cutoff frequency
    
    % Create Butterworth filter coefficients
    [b, a] = butter(n, (w/(fs/2)));
    
    coeff = 0.1;
end
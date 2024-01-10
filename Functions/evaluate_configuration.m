function evaluate_configuration(varargin)
    out = varargin{1};
    wpts = varargin{2};

    resultStateError = out.state_error;
    timeError = resultStateError.Time;
    errorData = abs(resultStateError.Data);
    
    analysisDetailQA = string(input("Full analysis (1) or Narrow Analysis (2): "));
    
    AccError = sum(errorData, 1); % Total Error for Each State
        
    AccTotalError = sum(AccError);
    
    PosErrorVSTime = errorData(:,10:12);
    
    meanErrorState = mean(mean(errorData));

    meanErrorX = mean(PosErrorVSTime(:,1));
    
    meanErrorY = mean(PosErrorVSTime(:,2));
    
    meanErrorZ = mean(PosErrorVSTime(:,3));
    
    meanErrorPos = meanErrorX + meanErrorY + meanErrorZ;
    
    state_names = {'\Phi [rad]', '\Theta [rad]', '\Psi [rad]', 'p [rad/s]', 'q [rad/s]', 'r [rad/s]', 'u [m/s]', 'v [m/s]', 'w [m/s]', 'x [m]', 'y [m]', 'z [m]'};
    
    if strcmp(analysisDetailQA, '1')   
          
        figure(1)
        for k = 1:12
            subplot(2,6,k)
            plot(timeError, errorData(:,k))
            ylabel(state_names(k))
            xlabel("Time [s]")
        end
       
    
    elseif strcmp(analysisDetailQA, '2')
        figure(1)
        for k = 10:12
            pltnr = k-9;
            subplot(1,3,pltnr)
            plot(timeError, errorData(:,k))
            ylabel(state_names(k))
            xlabel("Time [s]")
        end
    
    
    
    end
    
    fprintf(['Mean State Error in X: %d m' ...
             '\nMean State Error in Y: %d m' ...
             '\nMean State Error in Z: %d m' ...
             '\nMean State Error in Position: %d m ...' ...
             '\nMean State Error: %d \n'], meanErrorX, meanErrorY, meanErrorZ, meanErrorPos, meanErrorState)
        
    
    saveResultQA = string(input('Interested in saving the result? (1=YES): '));
    
    
    % Saving results in variables for future handling----------------------->
    
    if strcmp(saveResultQA, '1')
    
        % Saving results of Errors-------------->
    
        errorResult.AccError = sum(errorData, 1);
    
        errorResult.AccTotalError = AccTotalError;
    
        errorResult.PosErrorVSTime = PosErrorVSTime;
    
        errorResult.MeanErrorX = meanErrorX;
    
        errorResult.MeanErrorX = meanErrorY;
    
        errorResult.MeanErrorX = meanErrorZ;
    
        errorResult.MeanErrorPos = meanErrorPos;
    
        errorResult.String = append('Mean State Error in X: ', string(meanErrorX), ' m \n', ...
                                    'Mean State Error in Y: ', string(meanErrorY), ' m \n', ...
                                    'Mean State Error in Z: ', string(meanErrorZ), ' m \n', ...
                                    'Mean State Error in Position: ', string(meanErrorPos) ,' m');
    
        
        comment = string(input('Provide a summarizing comment: ','s'));
    
        errorResult.comment = comment;
    
    
        % Saving results of Errors--------------<
        %-
        %-
        % Saving associated system parameters--->

        

        settingStruct.EKF.R_noise = matfile(append(pwd, '/System Parameters/EKF2/ProcNoiseCov.mat')).R_noise; 
        settingStruct.EKF.Q_noise = matfile(append(pwd, '/System Parameters/EKF2//MeasNoiseCov.mat')).Q_noise; 
        settingStruct.LQR.Q = matfile(append(pwd, '/System Parameters/EKF2/CostState.mat')).Q;
        settingStruct.LQR.R = matfile(append(pwd, '/System Parameters/EKF2/CostInput.mat')).R;
        settingStruct.pathinfo = wpts;
        
    
        % Saving associated system parameters----<
    
        
    end
    
    % Saving results in variables for future handling-----------------------<
    %-
    %-
    % Saving Results in the correct directory------------------------------->
    %-
    %-
    % Working out a good directory name------------------------------->
    
    current_directory = pwd;
    
    dateString = datestr(datetime('now'), 'yyyy-mm-dd');
    
    namePrefix = append('Run_at_', dateString);
    
    dirPathPrefix = append(current_directory,'\Results\', namePrefix);
    
    copy_nr = 0;

    contents = dir(append(current_directory, '\Results'));

    for i = 1:length(contents)
        % Check if the item is a directory and not '.' or '..'
        if contents(i).isdir && ~strcmp(contents(i).name, '.') && ~strcmp(contents(i).name, '..')
            nameParts2BeComp = strsplit(contents(i).name, '_Nr_');
    
            if strcmp(nameParts2BeComp{1}, namePrefix)
                copy_nr = max(str2double(nameParts2BeComp{2}) + 1, copy_nr);
    
            end
    
        end
    end
    
    dirPathSuffix = append('_Nr_',string(copy_nr));
    
    dirPath = append(dirPathPrefix, dirPathSuffix);
    
    % Working out a good directory name-------------------------------<
    %-
    %-
    % Creating Directory of that name------------------------------->
    
    mkdir(dirPath);
    
    % Creating Directory of that name-------------------------------<
    %-
    %-
    % Saving results within that directory-------------------------->
    
    plotPath = append(dirPath, '\ErrorResultPlot.png');
    
    errorStructPath = append(dirPath, '\ResultErrorStruct.mat');
    
    settingStructPath = append(dirPath, '\ResultSettingStruct.mat');
    

    if exist(append(pwd,'\tempMovieSpace.avi'), 'file') == 2

        videoFileBase = append(pwd,'\tempMovieSpace.avi');
    
        videoFile = append(dirPath, '\Movie.avi');
    
        movefile(videoFileBase, videoFile);
    end
    
    % Save the struct to the specified file
    if strcmp(saveResultQA, '1')
        save(errorStructPath, 'errorResult');
        
        save(settingStructPath, 'settingStruct');
    
        saveas(gcf, plotPath)
    end
    
    % Saving results within that directory--------------------------<
    %-
    %-
    % Saving Results in the correct directory-------------------------------<

end
function compare_results(varargin)
% Function to compare results based on user input and visualize data

% Populate Dataset based from Result folder ------------------------------------> 
resultDirectory = append(pwd, '\Results');

resultFolders = dir(resultDirectory);

folderSize = size(resultFolders,1);
Dataset = cell(folderSize-2,1);

for folder_nr = 1:folderSize
    
    resultFolder = resultFolders(folder_nr);

    if ~strcmp(resultFolder.name, '.') && ~strcmp(resultFolder.name, '..')
        if size(varargin,2) > 0
            
            date_range = varargin{1};
            folder_date = strtok(resultFolder.name, ['Run_at_', '_Nr_']);
            
            if datenum(date_range{1}) <= datenum(folder_date) && datenum(folder_date)<= datenum(date_range{2})

               Dataset{folder_nr}.Settings = load(fullfile(resultDirectory, resultFolder.name, 'ResultSettingStruct.mat'));
               Dataset{folder_nr}.Errors = load(fullfile(resultDirectory, resultFolder.name, 'ResultErrorStruct.mat'));
               Dataset{folder_nr}.names = resultFolder.name;
        end
        end

    end

end
% Populate Dataset based from Result folder ------------------------------------< 


Dataset = Dataset(3:end);


% Extract folders corresponding to chosen Trajectory ------------------------------------>
trajectoryNames = {};

for idx = 1:numel(Dataset)
    trajName = Dataset{idx}.Settings.settingStruct.pathinfo.traj_name;
    trajectoryNames = [trajectoryNames; trajName];
end

uniqueTrajectoryNames = unique(trajectoryNames);

disp('Select a trajectory to evaluate:')
for idx = 1:numel(uniqueTrajectoryNames)
    disp([num2str(idx) '. ' uniqueTrajectoryNames{idx}]);
end

trajectoryChoice = input('Enter the number corresponding to the trajectory: ');
chosenTrajectoryName = uniqueTrajectoryNames{trajectoryChoice};

chosenTrajectoryDataset = {};

for idx = 1:numel(Dataset)
    if strcmp(Dataset{idx}.Settings.settingStruct.pathinfo.traj_name, chosenTrajectoryName)
        chosenTrajectoryDataset{end + 1} = Dataset{idx};
    end
end
% Extract folders corresponding to chosen Trajectory ------------------------------------< 


names = cell(numel(chosenTrajectoryDataset),1);
ID = (1:numel(chosenTrajectoryDataset))';


% Sorting, plotting and visualizing ------------------------------------> 
choice = string(input('Choose Errortyp Sorting: MSE Position - (1), MSE State - (2), ACC State Error - (3): '));

if strcmp(choice,'1')
    choice = 'Errors.errorResult.MeanErrorPos';
elseif strcmp(choice,'2')
    choice = 'Errors.errorResult.MeanErrorX';
elseif strcmp(choice,'3')
    choice = 'Errors.errorResult.AccTotalError';
end

[SortedDataset, Errors] = sort_result(chosenTrajectoryDataset, choice);

for index = 1:numel(SortedDataset)
    names{index} = SortedDataset{index}.names;
end

param_names = {'Q_7', 'Q_8', 'Q_9','R_{10}','R_{11}','R_{12}'};

figure()

for param = 1:3
    subplot(2,3,param);
    grid on
    hold on;
    
    xmax = 0;
    ymax = 0;
    xmin = inf;
    ymin = inf;
    
    labels = zeros(numel(SortedDataset), 2);

    for index = 1:numel(SortedDataset)
        xpos = SortedDataset{index}.Settings.settingStruct.EKF.Q_noise(6+param,6+param);
        xmax = max(xmax, xpos);
        xmin = min(xmin, xpos);
        
        ypos = Errors(index);
        ymax = max(ymax, ypos);
        ymin = min(ymin, ypos);
    
        labels(index,:) = [xpos, ypos];
    end

    scatter(labels(:,1), labels(:,2), 'Marker', '.', 'MarkerEdgeColor', 'black');

    ywidth = ymax-ymin;
    xwidth = xmax-xmin;

    for index = 1:numel(SortedDataset)
        text(labels(index,1) + 0.05*xwidth, labels(index,2) + 0.05*ywidth, num2str(index), 'Color', 'Black', 'FontSize', 8);
    end
    
    if xwidth ~= 0 && ywidth ~= 0
        xlim([xmin - xwidth*0.1, xmax + 0.1*xwidth])
        ylim([ymin - ywidth*0.1, ymax + 0.1*ywidth])
        p = polyfit(labels(:,1), labels(:,2), 1);
        f = polyval(p, labels(:,1));
        plot(labels(:,1), f, '-');
    end
    
    title(param_names(param));
    ylabel('Error');
    hold off;
end

for param = 1:3
    subplot(2,3,3+param);
    hold on;

    grid on
    hold on;
    
    xmax = 0;
    xmin = inf;
    
    labels = zeros(numel(SortedDataset), 2);

    for index = 1:numel(SortedDataset)
        xpos = SortedDataset{index}.Settings.settingStruct.EKF.R_noise(9+param,9+param);
        xmax = max(xmax, xpos);
        xmin = min(xmin, xpos);

        ypos = Errors(index);
        
        labels(index,:) = [xpos, ypos];
        
    end

    scatter(labels(:,1), labels(:,2), 'Marker', '.', 'MarkerEdgeColor', 'black');

    ywidth = ymax-ymin;
    xwidth = xmax-xmin;
    
    for index = 1:numel(SortedDataset)
        text(labels(index,1) + 0.05*xwidth, labels(index,2) + 0.05*ywidth, num2str(index), 'Color', 'Black', 'FontSize', 8);
    end
    
    if xwidth ~= 0 && ywidth ~= 0
        xlim([xmin - xwidth*0.1, xmax + 0.1*xwidth])
        ylim([ymin - ywidth*0.1, ymax + 0.1*ywidth])
        p = polyfit(labels(:,1),labels(:,2),1);
        f = polyval(p,labels(:,1)');
        plot(labels(:,1), f, '-');    
    end
    
    title(param_names(param+3));
    ylabel('Error');
    hold off;
end

hold off

T = table(ID, names, Errors);
disp(T)
% Sorting, plotting and visualizing ------------------------------------<

end

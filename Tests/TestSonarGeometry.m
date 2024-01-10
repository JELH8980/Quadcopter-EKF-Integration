
clear all; close all; clc
% Loading Test data ---------------------------->

addpath(append(pwd, '\SonarTestData'))

load('TerrainData.mat')

fileList = dir(append(pwd, '\SonarTestData'));

for i = 3:numel(fileList)
    filename = fileList(i).name;
    load(filename)
end


% Loading Test data ----------------------------<

% Acquiring Terrain data------------------------>

res = terrainData.res;

Surface = terrainData.Surf;

flatplane = 1;

xlimits = terrainData.limits{1};
ylimits = terrainData.limits{2};

Xgrid = (xlimits(1):res:xlimits(2));
Ygrid = (ylimits(1):res:ylimits(2));


% Acquiring Terrain data------------------------<

% Acquiring Drone Simulation data--------------->

PositionEstimateB0 = out.estimated_state.Data(:,10:12)';

PositionEstimateB0(3,:) = PositionEstimateB0(3,:)-3;

R_B02S = [1, 0, 0;
          0,-1, 0;
          0, 0,-1];


PositionEstimateS = R_B02S*PositionEstimateB0;


TimeVec = out.estimated_state.Time;


% Preprocessed graphices-------------------------------------->
figure()

xlabel('X')
ylabel('Y')
hold on
grid on
view(45, 45)
surf(Xgrid(1:end-1), Ygrid(1:end-1), Surface(:,:,1), 'FaceColor', 'red', 'EdgeColor','none')
surf(Xgrid(1:end-1), Ygrid(1:end-1), zeros(numel(Ygrid)-1, numel(Xgrid)-1), 'FaceColor', 'yellow', 'EdgeColor','none')
colormap('summer');

plot3(PositionEstimateS(1,:), PositionEstimateS(2,:), PositionEstimateS(3,:), 'color', 'm', 'LineWidth', 3)

xlim([xlimits(1) xlimits(2)])
ylim([ylimits(1) ylimits(2)])
zlim([0 40])

title('Environment');
axis equal;

% Preprocessed graphices--------------------------------------<

% Preprocessed memory-------------------------------------->

readings = zeros(3,numel(TimeVec));

FlatIterations = zeros(1, numel(TimeVec));

ConvexIterations = zeros(1, numel(TimeVec));

% Preprocessed memory--------------------------------------<

% Initial settings Newtons method---------------------->
tol = 0.1;

err = 100;

errors = zeros(1, numel(TimeVec));


% Initial settings Newtons method----------------------<


% Preprocessing of frame data for visualization and calculation--->
resultBodyframe = out.R_B2B0;

FrameS = pagemtimes(R_B02S, resultBodyframe);


% Preprocessing of frame data for visualization and calculation---<




for k = 1:numel(TimeVec)

Euler = out.estimated_state.Data(k,1:3);

phi = Euler(1);

theta = Euler(2);

psi = Euler(3);

b3 = FrameS(:,3,k);

Xd = PositionEstimateS(1,k);

Yd = PositionEstimateS(2,k);

Zd = PositionEstimateS(3,k);

i = floor((Xd + map_margin)/res);

j = floor((Yd + map_margin)/res);

id = Surface(j,i,2);

Det = SigmaDet(1, id);

Inv = SigmaInv(:, 2*(id-1)+1:2*(id-1)+2);

height = H(id);

mu = centerPoints(id,:)';

factor = height/(2*pi*sqrt(Det));

solutionFlags = zeros(1,k);

if factor*(-1/2*(Inv(1,1) *(Xd-mu(1))^2 - Inv(2,2) * (Yd-mu(2))^2)) < flatplane
    
    w = [1  0  -b3(1); ...
         0  1  -b3(2); ...
         0  0 -b3(3)]\[Xd;Yd;Zd];
    disp('Flat Surface')
    disp('Succeded Flat Case')
    FlatIterations(k) =   FlatIterations(k) + 1;

else


    fun =  @(w) [Xd+b3(1)*w(3) -  w(1);  Yd+b3(2)*w(3) -  w(2); Zd+b3(3)*w(3) - factor*(-1/2*(Inv(1,1) *(w(1)-mu(1))^2 - Inv(2,2) * (w(2)-mu(2))^2))+flatplane];

    [w, ~, ExitFlag] = fsolve(fun, [Xd;Yd;0]);
       
    T = 1;

    while T

        fprintf('Gaussian Height is: %d \n', factor*(-1/2*(Inv(1,1) *(Xd-mu(1))^2 - Inv(2,2) * (Yd-mu(2))^2))-flatplane)
        fprintf('Exit flag is %d \n', ExitFlag)

        T = input('Continue: ');
    end
    solutionFlags(k) = ExitFlag;

    


    disp('Succeded Convex Case')

end
    point = [Xd; Yd; Zd]+b3*w(3);
    if mod(k, 10) == 0
    plot3(point(1), point(2), point(3), 'Marker','*','color', 'g', 'LineWidth', 1)
    drawnow
    pause(0.01)
    end
   
end


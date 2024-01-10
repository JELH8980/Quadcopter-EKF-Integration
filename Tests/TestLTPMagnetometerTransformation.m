%% Test transformation between Magnetometer, LTP Frame and Inertial frame

% Author: Ludwig Horvath
% Date: 12/20/2023

% Code canbe recycled for other means but serves to prove that the
% transformation is indeed valid.

clear all;close all;clc

addpath(append(erase(pwd, '\Tests'), '\Functions'))

theta_d = deg2rad(5);  % Angle meassured from Geo meridian to Mag meridian

originLTP = zeros(3);

% Draw line to magnetic north

vecMAGN = [100; 0; 0];

vecMAGN = rotate('3', deg2rad(90) + theta_d, 'CCW')*vecMAGN;

% LTP Frame
FrameLTP = eye(3);

% SO Frame

BetaVec = (0:2*pi/100:deg2rad(720));

noFrames = size(BetaVec,2);

FrameMatrixS0 = zeros(3, noFrames*3);

originS0 = zeros(3);

FrameS0 = eye(3);

PsiVec = BetaVec + theta_d;

for i=1:noFrames

FrameMatrixS0(:,3*(i-1)+1:3*i) = rotate('3', PsiVec(i), 'CCW')*FrameS0;

end


figure();
ax = gca;
set(gcf, 'Color', [1, 1, 1]);
axis equal
xlim([-2 2])
ylim([-2 2])
zlim([-2 2])
view(0, 90)
grid on
xlabel('E')
ylabel('N')
zlabel('U')



% Preprocessing static elements
plot3([originLTP(1,1), vecMAGN(1,1)], ...
    [originLTP(2,1), vecMAGN(2,1)], ...
    [originLTP(3,1), vecMAGN(3,1)], 'LineStyle','--', 'color', 'm')

hold on

plot3([originLTP(1,1), FrameLTP(1,1)], ...
    [originLTP(2,1), FrameLTP(2,1)], ...
    [originLTP(3,1), FrameLTP(3,1)], 'linew', 2, 'color', 'b')

plot3([originLTP(1,2), FrameLTP(1,2)], ...
    [originLTP(2,2), FrameLTP(2,2)], ...
    [originLTP(3,2), FrameLTP(3,2)], 'linew', 2,  'color', 'b')
plot3([originLTP(1,3), FrameLTP(1,3)], ...
    [originLTP(2,3), FrameLTP(2,3)], ...
    [originLTP(3,3), FrameLTP(3,3)], 'linew', 2,  'color', 'b')


DisplayedN = text(FrameLTP(1,1)*1.1,FrameLTP(1,2)*1.1, "E");
DisplayedE = text(FrameLTP(2,1)*1.1,FrameLTP(2,2)*1.1, "N");
DisplayedU = text(FrameLTP(3,1)*1.1,FrameLTP(3,2)*1.1, "U");
     

FrameS0 = FrameMatrixS0(:,1:3);

X_0 = plot3([originS0(1,1), FrameS0(1,1)], ...
             [originS0(2,1), FrameS0(2,1)], ...
             [originS0(3,1), FrameS0(3,1)], 'linew', 2, 'color', 'r');

Y_0 = plot3([originS0(1,2), FrameS0(1,2)], ...
             [originS0(2,2), FrameS0(2,2)], ...
             [originS0(3,2), FrameS0(3,2)], 'linew', 2,  'color', 'r');

Z_0 = plot3([originS0(1,3), FrameS0(1,3)], ...
            [originS0(2,3), FrameS0(2,3)], ...
            [originS0(3,3), FrameS0(3,3)], 'linew', 2,  'color', 'r');


DisplayedText = text(0.1, 0.9, sprintf('θ_d: %s\nBeta: %s\nPsi_0: %s', ...
    num2str(theta_d, 2), num2str(BetaVec(i), 2), num2str(PsiVec(i), 2)), 'FontSize', 12);
set(DisplayedText, 'Interpreter', 'tex');

DisplayedX0 = text(FrameS0(1,1)*1.1,FrameS0(2,1)*1.1, "X_0");
DisplayedY0 = text(FrameS0(1,2)*1.1,FrameS0(2,2)*1.1, "Y_0");
DisplayedZ0 = text(FrameS0(1,3)*1.1,FrameS0(2,3)*1.1, "Z_0");

for i=1:noFrames
    delete(X_0);
    delete(Y_0);
    delete(Z_0);

    delete(DisplayedText);
    delete(DisplayedX0);
    delete(DisplayedY0);
    delete(DisplayedZ0);

    FrameS0 = FrameMatrixS0(:,3*(i-1)+1:3*i);
    
    X_0 = plot3([originS0(1,1), FrameS0(1,1)], ...
                 [originS0(2,1), FrameS0(2,1)], ...
                 [originS0(3,1), FrameS0(3,1)], 'linew', 2, 'color', 'r');
    
    Y_0 = plot3([originS0(1,2), FrameS0(1,2)], ...
                 [originS0(2,2), FrameS0(2,2)], ...
                 [originS0(3,2), FrameS0(3,2)], 'linew', 2,  'color', 'r');
    
    Z_0 = plot3([originS0(1,3), FrameS0(1,3)], ...
                [originS0(2,3), FrameS0(2,3)], ...
                [originS0(3,3), FrameS0(3,3)], 'linew', 2,  'color', 'r');
    
    axis equal
    xlim([-2 2])
    ylim([-2 2])
    zlim([-2 2])
    view(0, 90)
    grid on
    xlabel('E')
    ylabel('N')
    zlabel('U')

    DisplayedX0 = text(FrameS0(1,1)*1.1,FrameS0(2,1)*1.1, "X_0");
    DisplayedY0 = text(FrameS0(1,2)*1.1,FrameS0(2,2)*1.1, "Y_0");
    DisplayedZ0 = text(FrameS0(1,3)*1.1,FrameS0(2,3)*1.1, "Z_0");

     


    DisplayedText = text(1.1, 1.5, sprintf('θ_d: %s\nBeta: %s\nPsi_0: %s', ...
        num2str(rad2deg(theta_d), 4), num2str(rad2deg(BetaVec(i)), 4), num2str(rad2deg(PsiVec(i)), 2)), 'FontSize', 12);
    set(DisplayedText, 'Interpreter', 'tex');


    pause(0.1)

end


% Test transformation between Magnetometer, LTP Frame and Body Frame.

% Author: Ludwig Horvath
% Date: 12/20/2023

% Code can be recycled for other means but serves to prove that the
% transformation is indeed valid.

clear all;close all;clc


addpath(append(erase(pwd, '\Tests'), '\Functions'))


theta_d = deg2rad(5);  % Angle meassured from Geo meridian to Mag meridian

Psi0 = deg2rad(5);    % Angle meassured from E to X0 CCW

Beta = deg2rad(0);    % Angle meassured from line of Mag NP to X0 CCW

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

FrameS0 = rotate('3', Psi0, 'CCW')*FrameS0;




PsiVec = BetaVec + theta_d;

originSb = zeros(3);

FrameSb = eye(3);

for i=1:noFrames

FrameMatrixSb(:,3*(i-1)+1:3*i) = rotate('3', PsiVec(i), 'CCW')*rotate('1', deg2rad(180), 'CCW')*FrameSb;
% Order matters, otherwise the direction of Psi is flipped

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
    [originLTP(3,1), FrameLTP(3,1)], 'linew', 2, 'color', 'r')

plot3([originLTP(1,2), FrameLTP(1,2)], ...
    [originLTP(2,2), FrameLTP(2,2)], ...
    [originLTP(3,2), FrameLTP(3,2)], 'linew', 2,  'color', 'r')
plot3([originLTP(1,3), FrameLTP(1,3)], ...
    [originLTP(2,3), FrameLTP(2,3)], ...
    [originLTP(3,3), FrameLTP(3,3)], 'linew', 2,  'color', 'r')


DisplayedN = text(FrameLTP(1,1)*1.1,FrameLTP(1,2)*1.1, "E");
DisplayedE = text(FrameLTP(2,1)*1.1,FrameLTP(2,2)*1.1, "N");
DisplayedU = text(FrameLTP(3,1)*1.1,FrameLTP(3,2)*1.1, "U");
     


X_0 = plot3([originS0(1,1), FrameS0(1,1)], ...
             [originS0(2,1), FrameS0(2,1)], ...
             [originS0(3,1), FrameS0(3,1)], 'linew', 2, 'color', [1, 0.647, 0]);

Y_0 = plot3([originS0(1,2), FrameS0(1,2)], ...
             [originS0(2,2), FrameS0(2,2)], ...
             [originS0(3,2), FrameS0(3,2)], 'linew', 2, 'color', [1, 0.647, 0]);

Z_0 = plot3([originS0(1,3), FrameS0(1,3)], ...
            [originS0(2,3), FrameS0(2,3)], ...
            [originS0(3,3), FrameS0(3,3)], 'linew', 2,  'color', [1, 0.647, 0]);


DisplayedText = text(0.1, 0.9, sprintf('θ_d: %s\nBeta: %s\nPsi: %s', ...
    num2str(theta_d, 2), num2str(BetaVec(i), 2), num2str(PsiVec(i), 2)), 'FontSize', 12);
set(DisplayedText, 'Interpreter', 'tex');

DisplayedX0 = text(FrameS0(1,1)*1.1,FrameS0(2,1)*1.1, "X_0");
DisplayedY0 = text(FrameS0(1,2)*1.1,FrameS0(2,2)*1.1, "Y_0");
DisplayedZ0 = text(FrameS0(1,3)*1.1,FrameS0(2,3)*1.1, "Z_0");


FrameSb = FrameMatrixSb(:,1:3);

X_b = plot3([originSb(1,1), FrameSb(1,1)], ...
            [originSb(2,1), FrameSb(2,1)], ...
            [originSb(3,1), FrameSb(3,1)], 'linew', 2, 'color', 'k');

Y_b = plot3([originSb(1,2), FrameSb(1,2)], ...
            [originSb(2,2), FrameSb(2,2)], ...
            [originSb(3,2), FrameSb(3,2)], 'linew', 2,  'color', 'k');

Z_b = plot3([originSb(1,3), FrameSb(1,3)], ...
            [originSb(2,3), FrameSb(2,3)], ...
            [originSb(3,3), FrameSb(3,3)], 'linew', 2,  'color', 'k');


Y_bMinus = plot3([originSb(1,2), -FrameSb(1,2)], ...
                 [originSb(2,2), -FrameSb(2,2)], ...
                 [originSb(3,2), -FrameSb(3,2)], 'linew', 2,  'color', 'k', 'LineStyle', '--');


DisplayedXb = text(FrameSb(1,1)*1.1,FrameSb(2,1)*1.1, "X_b");
DisplayedYb = text(FrameSb(1,2)*1.1,FrameSb(2,2)*1.1, "Y_b");
DisplayedZb = text(FrameSb(1,3)*1.1,FrameSb(2,3)*1.1, "Z_b");



for i=1:noFrames
    delete(X_b);
    delete(Y_b);
    delete(Z_b);

    delete(DisplayedText);
    delete(DisplayedXb);
    delete(DisplayedYb);
    delete(DisplayedZb);
    delete(Y_bMinus)

    FrameSb = FrameMatrixSb(:,3*(i-1)+1:3*i);
    
    X_b = plot3([originSb(1,1), FrameSb(1,1)], ...
                 [originSb(2,1), FrameSb(2,1)], ...
                 [originSb(3,1), FrameSb(3,1)], 'linew', 2, 'color', 'k');
    
    Y_b = plot3([originSb(1,2), FrameSb(1,2)], ...
                 [originSb(2,2), FrameSb(2,2)], ...
                 [originSb(3,2), FrameSb(3,2)], 'linew', 2,  'color', 'k');
    
    Z_b = plot3([originSb(1,3), FrameSb(1,3)], ...
                [originSb(2,3), FrameSb(2,3)], ...
                [originSb(3,3), FrameSb(3,3)], 'linew', 2,  'color', 'k');


    Y_bMinus = plot3([originSb(1,2), -FrameSb(1,2)], ...
                 [originSb(2,2), -FrameSb(2,2)], ...
                 [originSb(3,2), -FrameSb(3,2)], 'linew', 2,  'color', 'k', 'LineStyle', '--');
    
    axis equal
    xlim([-2 2])
    ylim([-2 2])
    zlim([-2 2])
    view(0, 90)
    grid on
    xlabel('E')
    ylabel('N')
    zlabel('U')

    DisplayedXb = text(FrameSb(1,1)*1.1,FrameSb(2,1)*1.1, "X_b");
    DisplayedYb = text(FrameSb(1,2)*1.1,FrameSb(2,2)*1.1, "Y_b");
    DisplayedZb = text(FrameSb(1,3)*1.1,FrameSb(2,3)*1.1, "Z_b");

     


    DisplayedText = text(1.1, 1.5, sprintf('θ_d: %s\nBeta: %s\nPsi: %s', ...
        num2str(rad2deg(theta_d), 4), num2str(rad2deg(BetaVec(i)), 4), num2str(rad2deg(PsiVec(i)), 2)), 'FontSize', 12);
    set(DisplayedText, 'Interpreter', 'tex');


    pause(0.5)

end

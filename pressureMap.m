clear;clc;clf
import PressureSensor

%% Define Sensors
height_A = 0.05;
A1 = PressureSensor(0, height_A);
A2 = PressureSensor(2*pi*(1/8), height_A);
A3 = PressureSensor(2*pi*(1/4), height_A);
A4 = PressureSensor(2*pi*(3/8), height_A);
A5 = PressureSensor(2*pi*(1/2), height_A);
A6 = PressureSensor(2*pi*(5/8), height_A);
A7 = PressureSensor(2*pi*(3/4), height_A);
A8 = PressureSensor(2*pi*(7/8), height_A);

%% Set constants
a = 0.1778/2; % [m] ellipse major axis
b = 0.1270/2; % [m] ellipse minor axis
deltaTheta = .1; %[deg]
deltaZ = 0.0005;
z_min = 0.048;
z_max = 0.052;

%% Gather Pressure Readings from the Sensors

% get port - ls /dev/*.
% ard = arduino('/dev/tty.usbmodem1411', 'uno', 'Libraries', 'Servo');
% configurePin(ard, 'A0', 'AnalogInput');
% configurePin(ard, 'A1', 'AnalogInput');
% configurePin(ard, 'D3', 'pullup');

%% Set Sensors Currently Being Read -- ALSO NEED TO DO THIS BELOW
sensorArray = [A1 A2 A3 A4 A5 A6];
    
%% Iterate Through Values to set x y z data
i = 1;
numVals = floor((z_max-z_min)/deltaZ + 1) * floor(2*pi/deltaTheta + 1) + 1;
xData = zeros(1, numVals);
yData = zeros(1, numVals);
zData = zeros(1, numVals);
totalDistances = zeros(1, numVals);
colData = zeros(1, numVals);
for z = z_min:deltaZ:z_max
    for theta = 0:deltaTheta:2*pi
        r = a*b/(sqrt((b*cos(theta))^2+(a*sin(theta))^2));
        totalDistance = 0;
        for sensor = sensorArray
             distance = max(0.00000001, PressureSensor.getDistance(sensor, r, theta, z));
             totalDistance = 1/distance + totalDistance;
        end
        xData(i) = r*cos(theta);
        yData(i) = r*sin(theta);
        zData(i) = z;
        totalDistances(i) = totalDistance;
        i = i + 1;
    end
end
axis vis3d
s = scatter3([], [], [], 80, []);
colorbar
set(s, 'XData', xData, 'YData', yData, 'ZData', zData);

while s.BusyAction
    % Initialize Previous Pressure Sensor Readings
    A1.pressure = 5; % * readVoltage(ard, 'A1');
    A2.pressure = 1.2;
    A3.pressure = 8;
    A4.pressure = 1.2;
    A5.pressure = 5;% * readVoltage(ard, 'A0');
    A6.pressure = 1.2;
    
    %% Set Sensors Currently Being Read -- ALSO NEED TO DO THIS ABOVE
    sensorArray = [A1 A2 A3 A4 A5 A6];

    %% Iterate Through Values
    i = 1;
    for z = z_min:deltaZ:z_max
        for theta = 0:deltaTheta:2*pi
            pressureSum = 0;
            r = a*b/(sqrt((b*cos(theta))^2+(a*sin(theta))^2));
            for sensor = sensorArray
                distance = max(0.00000001, PressureSensor.getDistance(sensor, r, theta, z));
                weight = 1/(distance*totalDistances(1, i));
                pressureSum = pressureSum + sensor.pressure*weight;
            end
            colData(i) = pressureSum;
            i = i + 1;
        end
    end
    set(s, 'CData', colData);
    drawnow
    %disp('update')
end
clear ard
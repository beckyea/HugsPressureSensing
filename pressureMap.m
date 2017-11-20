clear;clc;clf
import PressureSensor

useHistoryPressures = false;

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

allSensors = [A1 A2 A3 A4 A5 A6 A7 A8];

%% Set constants
a = 0.1778/2; % [m] ellipse major axis
b = 0.1270/2; % [m] ellipse minor axis
deltaTheta = 5; %[deg]
numReadings = 100;

%% Gather Pressure Readings from the Sensors

% get port - ls /dev/*.
ard = arduino('/dev/tty.usbmodem1411', 'uno', 'Libraries', 'Servo');
configurePin(ard, 'A0', 'AnalogInput');
configurePin(ard, 'D3', 'pullup');

%Set 

for i = 0:numReadings

    A1.currentPressure = A1.currentPressure + 1.2;
    A2.currentPressure = A2.currentPressure +  1.2;
    A3.currentPressure = A3.currentPressure +  1.2;
    A4.currentPressure = A4.currentPressure +  1.2;
    A5.currentPressure = A5.currentPressure +  10 * readVoltage(ard, 'A0');
    A6.currentPressure = A6.currentPressure +  1.2;
    A7.currentPressure = A7.currentPressure +  1.2;
    A8.currentPressure = A8.currentPressure +  1.2;
end

%% Set Sensors Currently Being Used
sensorArray = [A1 A2 A3 A4 A5 A6 A7 A8];

%% Iterate Through Values
i = 1;
j = 1;
minP = inf;
maxP = 0;
for z = 0.048:0.0005:0.052
    for theta = 0:deltaTheta:360
        theta_rad = theta * pi / 180;
        pressureSum = 0;
        totalDistance = 0;
        r = a*b/(sqrt((b*cosd(theta))^2+(a*sind(theta))^2));
        for sensorIndex = 1:size(sensorArray')
            sensor = sensorArray(sensorIndex);
            distance = PressureSensor.getDistance(sensor, r, theta_rad, z);
            if (distance == 0)
                distane = 0.0000000001;
            end
            totalDistance = 1/distance^2 + totalDistance;
        end
        for sensorIndex = 1:size(sensorArray')
            sensor = sensorArray(sensorIndex);
            distance = PressureSensor.getDistance(sensor, r, theta_rad, z);
            weight = 1/(distance^2*totalDistance);
            pressureSum = pressureSum + sensor.currentPressure*weight;
        end
        xData(i) = r*cosd(theta);
        yData(i) = r*sind(theta);
        zData(i) = z;
        colData(i) = pressureSum;
        if pressureSum < minP
            minP = pressureSum;
        end
        if pressureSum > maxP
            maxP = pressureSum;
        end
        i = i + 1;
    end
end
axis vis3d
colormap spring
s = scatter3(xData, yData, zData, 80, colData);
colorbar
clear ard

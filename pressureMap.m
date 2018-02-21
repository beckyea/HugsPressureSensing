clear;clc;clf, close all
import PressureSensor

%% Define Sensors
K5 = PressureSensor('K', 5);
G5 = PressureSensor('G', 5);
C5 = PressureSensor('C', 5);
O5 = PressureSensor('O', 5);
S5 = PressureSensor('S', 5);
E6 = PressureSensor('E', 6);
M6 = PressureSensor('M', 6);
I6 = PressureSensor('I', 6);
A6 = PressureSensor('A', 6);
Q6 = PressureSensor('Q', 6);
K3 = PressureSensor('K', 3);
G3 = PressureSensor('G', 3);
C3 = PressureSensor('C', 3);
O3 = PressureSensor('O', 3);
S3 = PressureSensor('S', 3);
E4 = PressureSensor('E', 4);
M4 = PressureSensor('M', 4);
I4 = PressureSensor('I', 4);
A4 = PressureSensor('A', 4);
Q4 = PressureSensor('Q', 4);

%% Define States
states = [[K5 S5 A6 E4 S3];
          [G5 E6 Q6 I4 C3];
          [C5 M6 Q4 M4 G3];
          [O5 I6 A4 O3 K3];];


%% Gather Pressure Readings from the Sensors
ard = arduino('/dev/tty.usbmodem1411', 'uno', 'Libraries', 'Servo');
configurePin(ard, 'A0', 'AnalogInput');
configurePin(ard, 'A1', 'AnalogInput');
configurePin(ard, 'A2', 'AnalogInput');
configurePin(ard, 'A3', 'AnalogInput');
configurePin(ard, 'A4', 'AnalogInput');
configurePin(ard, 'A5', 'AnalogInput');
configurePin(ard, 'D3', 'pullup');
configurePin(ard, 'D4', 'pullup');
configurePin(ard, 'D3', 'DigitalOutput');
configurePin(ard, 'D4', 'DigitalOutput');
ardInd = ['A0'; 'A1'; 'A2'; 'A3'; 'A4'; 'A5'];

%% Set Graph Parameter
[numStates, sensorsPer] = size(states);
numVals = numStates * sensorsPer;
xData = zeros(1, numVals);
yData = zeros(1, numVals);
zData = zeros(1, numVals);
cData = zeros(1, numVals);
for state = 1:numStates
    for sensor = 1:sensorsPer
        index = sensor+(state-1)*sensorsPer;
        xData(index) = states(state, sensor).x;
        yData(index) = states(state, sensor).y;
        zData(index) = states(state, sensor).z;
    end
end
figure('Color','w')
axis vis3d
s = scatter3([], [], [], 80, []);
colorbar
colormap(jet)
caxis([0 10])
set(s, 'XData', xData, 'YData', yData, 'ZData', zData);
axis off

%% Gather Data
while true
     for state = 0:numStates-1
        %Configure Output Pins for State
        writeDigitalPin(ard, 'D3', mod(state, 2));
        writeDigitalPin(ard, 'D4', state > 1);
        pause(.2)
        %Update from sensor reading
        for sensor = 1:sensorsPer
            index = sensor + state*sensorsPer;
            cData(index) = readVoltage(ard, ardInd(sensor,:)) * 143;
        end
     end
%      avg = 0;
%      for i = 1:30
%         avg = avg + readVoltage(ard, 'A2');
%      end
%      avg = avg/30;
%      disp(avg)
   set(s, 'CData', cData);
   drawnow 
end
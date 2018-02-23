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

%% Create Cylinder
[Xcyl, Ycyl, Zcyl] = cylinder(2.75);
Xcyl = Xcyl * 3.5/2.75;
Zcyl = Zcyl*4 + 3;

%% Set Graph Parameter
[numStates, sensorsPer] = size(states);
numVals = numStates * sensorsPer;
valsToPlot = 20;
pauseTime = 0.2;
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
subplot(1,2,1)
hold on
surf(Xcyl, Ycyl, Zcyl, 'FaceColor', 'k', 'FaceAlpha', 0.2);
s = scatter3([], [], [], 80, []);
colorbar
colormap(jet)
caxis([0 20])
set(s, 'XData', xData, 'YData', yData, 'ZData', zData);
axis off

subplot(1,2,2)
ts = 0:pauseTime:(valsToPlot-1)*pauseTime;
values = zeros(numVals, valsToPlot);
hold on
legend('show');
plots = [plot(ts, zeros(numVals,1), 'Color', [.4 0  0], 'DisplayName', PressureSensor.getName(states(1,1)));
         plot(ts, zeros(numVals,1), 'Color', [.7 0 0], 'DisplayName', PressureSensor.getName(states(1,2)));
         plot(ts, zeros(numVals,1), 'Color', [1 0 0], 'DisplayName', PressureSensor.getName(states(1,3)));
         plot(ts, zeros(numVals,1), 'Color', [1 .5 0], 'DisplayName', PressureSensor.getName(states(1,4)));
         plot(ts, zeros(numVals,1), 'Color', [1 .7 0], 'DisplayName', PressureSensor.getName(states(1,5)));
         plot(ts, zeros(numVals,1), 'Color', [1 1 0], 'DisplayName', PressureSensor.getName(states(2,1)));
         plot(ts, zeros(numVals,1), 'Color', [0 .7 0], 'DisplayName', PressureSensor.getName(states(2,2)));
         plot(ts, zeros(numVals,1), 'Color', [0 .5 0], 'DisplayName', PressureSensor.getName(states(2,3)));
         plot(ts, zeros(numVals,1), 'Color', [0 .5 1], 'DisplayName', PressureSensor.getName(states(2,4)));
         plot(ts, zeros(numVals,1), 'Color', [0 .7 1], 'DisplayName', PressureSensor.getName(states(2,5)));
         plot(ts, zeros(numVals,1), 'Color', [0 0 1], 'DisplayName', PressureSensor.getName(states(3,1)));
         plot(ts, zeros(numVals,1), 'Color', [0 0 .7], 'DisplayName', PressureSensor.getName(states(3,2)));
         plot(ts, zeros(numVals,1), 'Color', [0 0 .5], 'DisplayName', PressureSensor.getName(states(3,3)));
         plot(ts, zeros(numVals,1), 'Color', [.5 0 .5], 'DisplayName', PressureSensor.getName(states(3,4)));
         plot(ts, zeros(numVals,1), 'Color', [.7 0 .7], 'DisplayName', PressureSensor.getName(states(3,5)));
         plot(ts, zeros(numVals,1), 'Color', [.1 0 .1], 'DisplayName', PressureSensor.getName(states(4,1)));
         plot(ts, zeros(numVals,1), 'Color', [.3 .3 .3], 'DisplayName', PressureSensor.getName(states(4,2)));
         plot(ts, zeros(numVals,1), 'Color', [.5 .5 .5], 'DisplayName', PressureSensor.getName(states(4,3)));
         plot(ts, zeros(numVals,1), 'Color', [.7 .7 .7], 'DisplayName', PressureSensor.getName(states(4,4)));
         plot(ts, zeros(numVals,1), 'Color', [0 0 0], 'DisplayName', PressureSensor.getName(states(4,5)))];
hold off


%% Gather Data
ind = 1;
while true
    ind = max(1, mod(ind, 20));
     for state = 0:numStates-1
        %Configure Output Pins for State
        writeDigitalPin(ard, 'D3', mod(state, 2));
        writeDigitalPin(ard, 'D4', state > 1);
   for i = 1:numStates
       for j = 1:sensorsPer
           index = j + (i-1)*sensorsPer;
           set(plots(index), 'YData', values(index,:));
       end
   end
        %Update from sensor reading
        for sensor = 1:sensorsPer
            index = sensor + state*sensorsPer;
            cData(index) = readVoltage(ard, ardInd(sensor,:)) * 143;
            values(index, ind) = cData(index); 
        end
     end
     ind = ind + 1;
   set(s, 'CData', cData);
   drawnow 
end
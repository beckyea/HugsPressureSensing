classdef PressureSensor
    properties
        r                  % radial distance from center [m]
        theta              % angle [degrees]
        z                  % height [m]
        currentPressure    % outputted pressure
        pressureHistory    % oreviouos pressure value
    end
    methods
        function obj = PressureSensor(theta_in, z_in)
           a = 0.1778/2;
           b = 0.1270/2;
           obj.theta = theta_in;
           obj.z = z_in;
           obj.r = a*b/(sqrt((b*cosd(theta_in))^2+(a*sind(theta_in))^2));
        end
    end
    methods (Static)
        function dist = getDistance(obj, r2, theta2, z)
            if (theta2 > 180)
                theta2 = 360 - theta2;
            end
            dTheta = abs(theta2 - obj.theta);
            
%             dTheta1 = mod(theta2 - obj.theta + 360, 360);
%             dTheta2 = mod(obj.theta - theta2 + 360, 360);
%             dTheta = min(dTheta1, dTheta2);
            
            dTheta_rad = dTheta * pi /180;
            avgR = (r2 + obj.r)/2;
            arcLength = dTheta_rad * avgR;
            dist = sqrt(arcLength^2 + (z-obj.z)^2);
%             dist = sqrt((z-obj.z)^2 + r2^2 + obj.r^2 - ...
%                         2*obj.r*r2*cosd(theta2-obj.theta));
        end
    end
end

    
classdef PressureSensor
    properties
        r                  % radial distance from center [m]
        theta              % angle [rad]
        z                  % height [m]
        pressure           % outputted pressure
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
            dTheta = mod(abs(theta2 - obj.theta), 180);
            arcLength = dTheta * (r2 + obj.r)/2;
            dist = arcLength^2 + (z-obj.z)^2;
        end
    end
end

    
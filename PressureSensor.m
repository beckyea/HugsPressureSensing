% Manequin has a = 3.5, b = 2.75

classdef PressureSensor
    properties
        radialVal
        x
        y
        z
    end
    methods
        function obj = PressureSensor(letter, height)
            obj.radialVal = double(uint8(letter) - 65);
            obj.z = height;
            theta = deg2rad(18*obj.radialVal);
            r = 3.5*2.75/(sqrt((2.75*cos(theta))^2+(3.5*sin(theta))^2));
            obj.x = r*cos(theta);
            obj.y = r*sin(theta);
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

    
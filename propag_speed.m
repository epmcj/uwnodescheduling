function q = propag_speed(d, s, t)
    % Calculates the propagation speed in m/s, where
    % d is the depth in km,
    % s is the salinity in ppt and
    % t is the temperature in °C.
    
    t = t/10;    
    q = 1449.05 + 45.7 * t - 5.21 * t^2 + 0.23 * t^3 + 16.3 * d + ...
        (1.333 - 0.126 * t + 0.009 * t^2) * (s - 35) + 0.18 * d^2;
    
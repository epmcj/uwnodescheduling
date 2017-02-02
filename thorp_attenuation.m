function atten = thorp_attenuation(frequency)
    % Thorp's attenuation formula.
    % in : frequency in kHz
    % out: 10 * log(attenuation_value) in dB/km
    
    f = frequency ^ 2;
    if f > 0.4
        atten = 0.11 * f / (1 + f) ... 
                + 44 * (f / (4100 + f)) ...
                + 2.75 * (10 ^ (-4)) * f + 0.003;
    else
        atten = 0.002 + 0.11 * f / (1 + f) + 0.011 * f;
    end
    
    
                
function n = noise(frequency)
    % Estimate the underwater noise.
	% in: frequency in kHz
    % out: noise in dB re uPa
    
    s = 0.0; % Shipping activity factor [0-1]
    w =   0; % Wind speed in m/s
    
    n_turbulence = 17 - 30 * log10(frequency);
    n_turbulence = 10 ^ (n_turbulence * 0.1);
    
    n_shipping = 40 + 20 * (s - 0.5) + ...
                 26 * log10(frequency) - ...
                 60 * log10(frequency + 0.03);
    n_shipping = 10 ^ (n_shipping * 0.1);
             
    n_wind = 50 + 7.5 * sqrt(w) + 20 * log10(frequency) - ...
             40 * log10(frequency + 0.4);
    n_wind = 10 ^ (n_wind * 0.1);
         
    n_thermal = 20 * log10(frequency) - 15;
    n_thermal = 10 ^ (n_thermal * 0.1);
    
    n = n_turbulence + n_shipping + n_wind + n_thermal;
    n = 10 * log10(n);
    
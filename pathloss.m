function x = pathloss(d, f, k)
    % Calculates the transmission loss that occurs in underwater acoustic channel
    % over a distance d, in m, for a signal of frequency f, in kHz.
    % The spreading factor k describe the geometry of the propagation and
    % its commonly used values are k = 2 for spherical spreading, k = 1 for
    % cylindrical spreading and k = 1.5 for pratical spreading.
    %
    % Paper: On the Relationship Between Capacity and Distance in an 
    % Underwater Acoustic Communication Channel.
    
    x = k * 10.0 * log10(d) + ...               Spreading loss
        d * thorp_attenuation(f) * 1000 + ...   Absortion loss
        10;                                   % Transmission anomaly
    
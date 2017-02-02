function x = NTX(PER)
    % Average number of transmissions.
    % PER - Packet Error Rate.
    
    x = 1.0 / (1.0 - PER);
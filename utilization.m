function x = utilization(headerSize, payloadSize, ACKSize, rate, NTX, RTT)
    % Channel utilization efficiency
    % FEC mechanism is not used. 
    
    tx = (payloadSize + headerSize) / rate; % headerSize = 32?
    tx = tx + ACKSize/rate;  % ACK = 1500 ?
    tx = tx + RTT;
    
    x = payloadSize / (rate * NTX * tx);
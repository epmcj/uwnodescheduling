function x = send_packet(A, B, f, psize)
    % Function that simulates the sending of an packet from A to B.
    % A - [X Y Z] in km
    % f - Frequency in kHz
    % psize - Packet size in bytes
    % Returns 1 if successfull, 0 otherwise.
    
    PER = per(sqrt(sum((A - B) .^ 2)), f, psize);

    if rand(1) > PER 
        x = 1;
    else
        x = 0;
    end
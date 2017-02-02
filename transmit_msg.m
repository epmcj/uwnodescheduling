function [res, nmsg, ne] = transmit_msg(nodes, sen, rcv, maxTry, energy,qt)
    % Tries to transmit a message from node sen to node rcv. Both should
    % have [x y z] format, where x, y, z are the coordinates in meters. The
    % packet has psize kB, and is transmitted using the frequency freq in a
    % maximum of maxTry tentatives. The rcv sends a ACK, of size acksize, 
    % when the message is received.
    
    nsend   = 0;
    res     = 1;
    freq    =  100; % in kHz
    psize   =  500; % in bytes
    acksize =  160; % in bytes  
    ne      = energy; % node energy
    ok      = 0;
    nmsg    = 0; % number of messages exchanged
    while ok == 0 && nsend < maxTry && ne(sen) > 0 && ne(rcv) > 0
        ne(sen) = ne(sen) - qt;
        nsend = nsend + 1;
        nmsg = nmsg + 1;
        % Try to send the message to the receiver.
        ok = send_packet(nodes(sen,:)/1000, nodes(rcv,:)/1000, freq,...
            psize);
        % If the message is received, then the receiver must send an ACK.
        if ok == 1
            ne(rcv) = ne(rcv) - qt;
            ok = send_packet(nodes(rcv,:)/1000, nodes(sen,:)/1000, freq,...
                acksize);
            nmsg = nmsg + 1;
        end
    end
    if nsend == maxTry || nsend == 0 || ne(sen) == 0 || ne(rcv) == 0
        res = 0;
    end
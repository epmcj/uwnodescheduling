function x = per(d, f, psize)
    % Packet Error Rate
    % distance d in km
    % frequency f in kHz
    % packet size psize in bytes
    
    k = 1.5;        % pratical spreading
    
    % TX power and Frequency option. Choose one:
    % Pt = 68;      % 1.2 kW
    % Pt = 50;      % 120 W
    % Pt = 46.98;	% WHOI modem: 50 Wa
    % Pt = (6+167); % dB re 1 uPa; UWM2000: 4W ==> 6dBW
    Pt = (0+62);	% dB re 1 uPa; UWM1000: 1W ==> 0dBW 
                                 % |->Freq: 26.77-44.62 kHz
    
    Pl = pathloss(d, f, k);
    Pl = (d ^ k) * (Pl^d);      % A(l,f) 
    nf = noise(f);              % N(f)
    df = 3;                     % BW = 3 dB 

    SNRdb = Pt - Pl - nf;%/ /(Pl * nf * df);
    SNR = 10 ^ (SNRdb/10);

    BER = 0.5 * (1 - sqrt(SNR/(1 + SNR)));
%disp(BER);
    x = 1.0 - (1.0 - BER) ^ (8 * psize);
    
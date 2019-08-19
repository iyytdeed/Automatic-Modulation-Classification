clear
close all

fc=30000000;
fd=6000000;
fs=fix(6*fc/fd)*fd;
Ts = 1/fs;
Td = 1/fd;
N = round(Td/Ts);
M = 256;
Nsample = M*N;
T0 = Nsample*Ts;
t = Ts:Ts:T0;

NClass = 6;
MonteCarloSum = 1000;
NFeatures = 5;
EsNo_low = 0;
EsNo_high = 20;
gap = 2;
EsNo_array = EsNo_low:gap:EsNo_high;
test_data = zeros(length(EsNo_array) * NClass * MonteCarloSum, NFeatures + 2);
for idx = 1:length(EsNo_array)
    SNR = EsNo_array(idx);
    disp(SNR);
    for MonteCarloCur = 1:MonteCarloSum
        % 2ASK signal
        G = randi([0,1],[1,M]);
        y = Digit_Modul(G, fd, fc, 'ASK', 2);
        [test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur, 1), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur, 2), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur, 3), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur, 4), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur, 5)] = getFeature(y, SNR, fc, fs, fd);
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur, 6) = 0;
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur, 7) = SNR;
        
        % 4ASK signal
        G = randi([0,3],[1,M]);
        y = Digit_Modul(G, fd, fc, 'ASK', 4);
        [test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+MonteCarloSum, 1),...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+MonteCarloSum, 2), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+MonteCarloSum, 3), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+MonteCarloSum, 4), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+MonteCarloSum, 5)] = getFeature(y, SNR, fc, fs, fd);
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+MonteCarloSum, 6) = 1;
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+MonteCarloSum, 7) = SNR;
        
        % 2PSK signal
        G = randi([0,1],[1,M]);
        y = Digit_Modul(G, fd, fc, 'PSK', 2);
        [test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+2*MonteCarloSum, 1),...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+2*MonteCarloSum, 2), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+2*MonteCarloSum, 3), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+2*MonteCarloSum, 4), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+2*MonteCarloSum, 5)] = getFeature(y, SNR, fc, fs, fd);
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+2*MonteCarloSum, 6) = 2;
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+2*MonteCarloSum, 7) = SNR;
        
        % 4PSK signal
        G = randi([0,3],[1,M]);
        y = Digit_Modul(G, fd, fc, 'PSK', 4);
        [test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+3*MonteCarloSum, 1),...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+3*MonteCarloSum, 2), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+3*MonteCarloSum, 3), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+3*MonteCarloSum, 4), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+3*MonteCarloSum, 5)] = getFeature(y, SNR, fc, fs, fd);
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+3*MonteCarloSum, 6) = 3;
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+3*MonteCarloSum, 7) = SNR;
        
        % 2FSK signal
        G = randi([0,1],[1,M]);
        y = Digit_Modul(G, fd, fc, 'FSK', 2);
        [test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+4*MonteCarloSum, 1),...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+4*MonteCarloSum, 2), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+4*MonteCarloSum, 3), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+4*MonteCarloSum, 4), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+4*MonteCarloSum, 5)] = getFeature(y, SNR, fc, fs, fd);
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+4*MonteCarloSum, 6) = 4;
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+4*MonteCarloSum, 7) = SNR;
        
        % 4FSK signal
        G = randi([0,3],[1,M]);
        y = Digit_Modul(G, fd, fc, 'FSK', 4);
        [test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+5*MonteCarloSum, 1),...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+5*MonteCarloSum, 2), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+5*MonteCarloSum, 3), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+5*MonteCarloSum, 4), ...
            test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+5*MonteCarloSum, 5)] = getFeature(y, SNR, fc, fs, fd);
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+5*MonteCarloSum, 6) = 5;
        test_data((idx-1)*NClass*MonteCarloSum+MonteCarloCur+5*MonteCarloSum, 7) = SNR;
    end
end

csvwrite('test.csv', test_data);
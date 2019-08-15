clear
clc
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

NTrain = 10000;
EsNo_low = 0;
EsNo_high = 20;
NClass = 6;
NFeatures = 5;
train_data = zeros(NClass * NTrain, NFeatures + 1);
for MonteCarloCur = 1:NTrain
    SNR = (EsNo_high - EsNo_low)*rand + EsNo_low;
    % 2ASK signal
    G = randi([0,1],[1,M]);
    y = Digit_Modul(G, fd, fc, 'ASK', 2);
    y = awgn(y, SNR, 'measured');
    [train_data(MonteCarloCur+0*NTrain, 1), ...
        train_data(MonteCarloCur+0*NTrain, 2), ...
        train_data(MonteCarloCur+0*NTrain, 3), ...
        train_data(MonteCarloCur+0*NTrain, 4), ...
        train_data(MonteCarloCur+0*NTrain, 5)] = getFeature(y, SNR, fc, fs, fd);
    train_data(MonteCarloCur+0*NTrain, 6) = 0;
    
    % 4ASK signal
    G = randi([0,3],[1,M]);
    y = Digit_Modul(G, fd, fc, 'ASK', 4);
    y = awgn(y, SNR, 'measured');
    [train_data(MonteCarloCur+NTrain, 1), ...
        train_data(MonteCarloCur+NTrain, 2), ...
        train_data(MonteCarloCur+NTrain, 3), ...
        train_data(MonteCarloCur+NTrain, 4), ...
        train_data(MonteCarloCur+NTrain, 5)] = getFeature(y, SNR, fc, fs, fd);
    train_data(MonteCarloCur+NTrain, 6) = 1;
    
    % 2PSK signal
    G = randi([0,1],[1,M]);
    y = Digit_Modul(G, fd, fc, 'PSK', 2);
    y = awgn(y, SNR, 'measured');
    [train_data(MonteCarloCur+2*NTrain, 1), ...
        train_data(MonteCarloCur+2*NTrain, 2), ...
        train_data(MonteCarloCur+2*NTrain, 3), ...
        train_data(MonteCarloCur+2*NTrain, 4), ...
        train_data(MonteCarloCur+2*NTrain, 5)] = getFeature(y, SNR, fc, fs, fd);
    train_data(MonteCarloCur+2*NTrain, 6) = 2;
    
    % 4PSK signal
    G = randi([0,3],[1,M]);
    y = Digit_Modul(G, fd, fc, 'PSK', 4);
    y = awgn(y, SNR, 'measured');
    [train_data(MonteCarloCur+3*NTrain, 1), ...
        train_data(MonteCarloCur+3*NTrain, 2), ...
        train_data(MonteCarloCur+3*NTrain, 3), ...
        train_data(MonteCarloCur+3*NTrain, 4), ...
        train_data(MonteCarloCur+3*NTrain, 5)] = getFeature(y, SNR, fc, fs, fd);
    train_data(MonteCarloCur+3*NTrain, 6) = 3;
    
    % 2FSK signal
    G = randi([0,1],[1,M]);
    y = Digit_Modul(G, fd, fc, 'FSK', 2);
    y = awgn(y, SNR, 'measured');
    [train_data(MonteCarloCur+4*NTrain, 1), ...
        train_data(MonteCarloCur+4*NTrain, 2), ...
        train_data(MonteCarloCur+4*NTrain, 3), ...
        train_data(MonteCarloCur+4*NTrain, 4), ...
        train_data(MonteCarloCur+4*NTrain, 5)] = getFeature(y, SNR, fc, fs, fd);
    train_data(MonteCarloCur+4*NTrain, 6) = 4;
    
    % 4FSK signal
    G = randi([0,3],[1,M]);
    y = Digit_Modul(G, fd, fc, 'FSK', 4);
    y = awgn(y, SNR, 'measured');
    [train_data(MonteCarloCur+5*NTrain, 1), ...
        train_data(MonteCarloCur+5*NTrain, 2), ...
        train_data(MonteCarloCur+5*NTrain, 3), ...
        train_data(MonteCarloCur+5*NTrain, 4), ...
        train_data(MonteCarloCur+5*NTrain, 5)] = getFeature(y, SNR, fc, fs, fd);
    train_data(MonteCarloCur+5*NTrain, 6) = 5;
end

csvwrite('train.csv', train_data);

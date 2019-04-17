clear
clc
%% init
j = sqrt(-1);
NTrain = 10000;
EsNo_low = -10;
EsNo_high = 20;
L = 100;
NClass = 4;
NFeatures = 9;
train_data = zeros(NClass * NTrain, NFeatures + 1);
%% get train data
% bpsk
signalData = zeros(NTrain, L);
noiseData = zeros(NTrain, L);
mod = comm.BPSKModulator();
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNo_high - EsNo_low)*rand + EsNo_low;
    P = 10^(EsNo/10);
    for col = 1:L
        s = x(unidrnd(xN));
        signalData(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
    end
end
cumulants = func_get_cumulants(signalData, noiseData);
for row = 1:NTrain
    for i = 1:NFeatures
        train_data(row, i) = cumulants(row, i);
    end
    train_data(row, NFeatures+1) = 0;
end
% qam4
signalData = zeros(NTrain, L);
noiseData = zeros(NTrain, L);
mod = comm.RectangularQAMModulator('ModulationOrder',4,...
        'NormalizationMethod','Average power','AveragePower', 1);
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNo_high - EsNo_low)*rand + EsNo_low;
    P = 10^(EsNo/10);
    for col = 1:L
        s = x(unidrnd(xN));
        signalData(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
    end
end
cumulants = func_get_cumulants(signalData, noiseData);
for row = 1:NTrain
    for i = 1:NFeatures
        train_data(row + NTrain, i) = cumulants(row, i);
    end
    train_data(row + NTrain, NFeatures+1) = 1;
end
% psk8
signalData = zeros(NTrain, L);
noiseData = zeros(NTrain, L);
mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNo_high - EsNo_low)*rand + EsNo_low;
    P = 10^(EsNo/10);
    for col = 1:L
        s = x(unidrnd(xN));
        signalData(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
    end
end
cumulants = func_get_cumulants(signalData, noiseData);
for row = 1:NTrain
    for i = 1:NFeatures
        train_data(row + 2*NTrain, i) = cumulants(row, i);
    end
    train_data(row + 2*NTrain, NFeatures+1) = 2;
end
% qam16
signalData = zeros(NTrain, L);
noiseData = zeros(NTrain, L);
mod = comm.RectangularQAMModulator('ModulationOrder',16,...
        'NormalizationMethod','Average power','AveragePower',1);
x = constellation(mod);
xN = length(x);
for row = 1:NTrain
    EsNo = (EsNo_high - EsNo_low)*rand + EsNo_low;
    P = 10^(EsNo/10);
    for col = 1:L
        s = x(unidrnd(xN));
        signalData(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
    end
end
cumulants = func_get_cumulants(signalData, noiseData);
for row = 1:NTrain
    for i = 1:NFeatures
        train_data(row + 3*NTrain, i) = cumulants(row, i);
    end
    train_data(row + 3*NTrain, NFeatures+1) = 3;
end
csvwrite('train.csv', train_data);

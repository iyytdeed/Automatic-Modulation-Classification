clear
clc
%% init
j = sqrt(-1);
NTest = 1000;
EsNoLow = -10;
EsNoHigh = 20;
gap = 2;
L = 100;
NClass = 4;
EsNo_array = EsNoLow:gap:EsNoHigh;
test_data = zeros(length(EsNo_array) * NClass * NTest, L + 2);
%% get test data
for idx = 1:length(EsNo_array)
    EsNo = EsNo_array(idx);
    disp(['EsNo = ', num2str(EsNo)]);
    P = 10^(EsNo/10);
    % bpsk
    signal_data = zeros(NTest, L + 2);
    mod = comm.BPSKModulator();
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 0;
        signal_data(row, L + 2) = EsNo;
    end
    for row = 1:NTest
        test_data((idx-1)*NClass*NTest+row, :) = signal_data(row, :);
    end
    % qam4
    signal_data = zeros(NTest, L + 2);
    mod = comm.RectangularQAMModulator('ModulationOrder',4,...
        'NormalizationMethod','Average power','AveragePower', 1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 1;
        signal_data(row, L + 2) = EsNo;
    end
    for row = 1:NTest
        test_data((idx-1)*NClass*NTest+row+NTest, :) = signal_data(row, :);
    end
    % psk8
    signal_data = zeros(NTest, L + 2);
    mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 2;
        signal_data(row, L + 2) = EsNo;
    end
    for row = 1:NTest
        test_data((idx-1)*NClass*NTest+row+2*NTest, :) = signal_data(row, :);
    end
    % qam16
    signal_data = zeros(NTest, L + 2);
    mod = comm.RectangularQAMModulator('ModulationOrder',16,...
        'NormalizationMethod','Average power','AveragePower',1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 3;
        signal_data(row, L + 2) = EsNo;
    end
    for row = 1:NTest
        test_data((idx-1)*NClass*NTest+row+3*NTest, :) = signal_data(row, :);
    end
end

save('./dataset/test_data.mat', 'test_data', '-mat');

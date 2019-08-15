clear
clc

%% init
NTest = 1000;
Phase_low = 0;
Phase_high = 90;
gap = 5;
L = 100;
EsNo = 10;
P = 10^(EsNo/10);
NClass = 4;
j = sqrt(-1);
phase_array = Phase_low:gap:Phase_high;
test_data = zeros(length(phase_array) * NClass * NTest, L + 2);
%% get test data
for idx = 1:length(phase_array)
    PhaseBound = phase_array(idx)*pi/180;
    fprintf("PhaseBound = %f\n", phase_array(idx));
    fprintf("PhaseBound = %f\n", PhaseBound);
    % bpsk
    signal_data = zeros(NTest, L + 2);
    mod = comm.BPSKModulator();
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signal_data(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 0;
        signal_data(row, L + 2) = phase_array(idx);
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
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signal_data(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 1;
        signal_data(row, L + 2) = phase_array(idx);
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
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signal_data(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 2;
        signal_data(row, L + 2) = phase_array(idx);
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
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signal_data(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 3;
        signal_data(row, L + 2) = phase_array(idx);
    end
    for row = 1:NTest
        test_data((idx-1)*NClass*NTest+row+3*NTest, :) = signal_data(row, :);
    end
end

save('./dataset/test_data_phasejitter.mat', 'test_data', '-mat');

clear
clc

%% init
NTest = 1000;
L = 100;
FeqOffset_low = 0;
FeqOffset_high = 0.25/L; % normalize to maximun rotation of 90 degree
gap = (FeqOffset_high - FeqOffset_low)/20;
EsNo = 10;
P = 10^(EsNo/10);
NClass = 4;
j = sqrt(-1);
freq_offset_array = FeqOffset_low:gap:FeqOffset_high;
test_data = zeros(length(freq_offset_array) * NClass * NTest, L + 2);
%% get test data
for idx = 1:length(freq_offset_array)
    FreqOffsetBound = freq_offset_array(idx)*(2*pi);
    fprintf("FreqOffsetBound = %f\n", freq_offset_array(idx));
    fprintf("FreqOffsetBound = %f\n", FreqOffsetBound);
    % bpsk
    signal_data = zeros(NTest, L + 2);
    mod = comm.BPSKModulator();
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        freq_offset = FreqOffsetBound;
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(freq_offset*col))*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 0;
        signal_data(row, L + 2) = freq_offset_array(idx);
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
        freq_offset = FreqOffsetBound;
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(freq_offset*col))*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 1;
        signal_data(row, L + 2) = freq_offset_array(idx);
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
        freq_offset = FreqOffsetBound;
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(freq_offset*col))*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 2;
        signal_data(row, L + 2) = freq_offset_array(idx);
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
        freq_offset = FreqOffsetBound;
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(freq_offset*col))*s + sqrt(1/2)*(randn+j*randn);
        end
        signal_data(row, L + 1) = 3;
        signal_data(row, L + 2) = freq_offset_array(idx);
    end
    for row = 1:NTest
        test_data((idx-1)*NClass*NTest+row+3*NTest, :) = signal_data(row, :);
    end
end

save('./dataset/test_data_freqOffset.mat', 'test_data', '-mat');

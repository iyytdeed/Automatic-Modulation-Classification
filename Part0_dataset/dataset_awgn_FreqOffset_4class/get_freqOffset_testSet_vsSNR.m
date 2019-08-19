clear
clc
%% init
j = sqrt(-1);
NTest = 1000;
EsNo_low = -10;
EsNo_high = 20;
gap = 2;
L = 100;
f0 = (40/360)/L;

NClass = 4;
NFeatures = 9;
EsNo_array = EsNo_low:gap:EsNo_high;
test_data = zeros(length(EsNo_array) * NClass * NTest, L+1);
%% get test data
for idx = 1:length(EsNo_array)
    EsNo = EsNo_array(idx);
    P = 10^(EsNo/10);
    % bpsk
    signal_data = zeros(NTest, L);
    mod = comm.BPSKModulator();
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(2*pi*f0*col))*s + sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+row;
        for i = 1:L
            test_data(row_r, i) = signal_data(row, i);
        end
        test_data(row_r, L+1) = 0;
        test_data(row_r, L+2) = EsNo;
    end
    % qam4
    signal_data = zeros(NTest, L);
    noiseData = zeros(NTest, L);
    mod = comm.RectangularQAMModulator('ModulationOrder',4,...
        'NormalizationMethod','Average power','AveragePower', 1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(2*pi*f0*col))*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+NTest+row;
        for i = 1:L
            test_data(row_r, i) = signal_data(row, i);
        end
        test_data(row_r, L+1) = 1;
        test_data(row_r, L+2) = EsNo;
    end
    % psk8
    signal_data = zeros(NTest, L);
    noiseData = zeros(NTest, L);
    mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(2*pi*f0*col))*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+2*NTest+row;
        for i = 1:L
            test_data(row_r, i) = signal_data(row, i);
        end
        test_data(row_r, L+1) = 2;
        test_data(row_r, L+2) = EsNo;
    end
    % qam16
    signal_data = zeros(NTest, L);
    noiseData = zeros(NTest, L);
    mod = comm.RectangularQAMModulator('ModulationOrder',16,...
        'NormalizationMethod','Average power','AveragePower',1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*exp(j*(2*pi*f0*col))*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+3*NTest+row;
        for i = 1:L
            test_data(row_r, i) = signal_data(row, i);
        end
        test_data(row_r, L+1) = 3;
        test_data(row_r, L+2) = EsNo;
    end
end

save('test_data.mat', 'test_data', '-mat');
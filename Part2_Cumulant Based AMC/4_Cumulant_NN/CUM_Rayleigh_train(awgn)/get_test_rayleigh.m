clear
clc
%% init
j = sqrt(-1);
NTest = 1000;
EsNo_low = -10;
EsNo_high = 20;
gap = 2;
L = 100;
NClass = 4;
NFeatures = 9;
EsNo_array = EsNo_low:gap:EsNo_high;
test_data = zeros(length(EsNo_array) * NClass * NTest, NFeatures + 2);
%% get test data
for idx = 1:length(EsNo_array)
    EsNo = EsNo_array(idx);
    P = 10^(EsNo/10);
    % bpsk
    signalData = zeros(NTest, L);
    noiseData = zeros(NTest, L);
    mod = comm.BPSKModulator();
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        h = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signalData(row, col) = sqrt(P)*h*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    cumulants = func_get_cumulants(signalData, noiseData);
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+row;
        for i = 1:NFeatures
            test_data(row_r, i) = cumulants(row, i);
        end
        test_data(row_r, NFeatures+1) = 0;
        test_data(row_r, NFeatures+2) = EsNo;
    end
    % qam4
    signalData = zeros(NTest, L);
    noiseData = zeros(NTest, L);
    mod = comm.RectangularQAMModulator('ModulationOrder',4,...
        'NormalizationMethod','Average power','AveragePower', 1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        h = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signalData(row, col) = sqrt(P)*h*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    cumulants = func_get_cumulants(signalData, noiseData);
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+NTest+row;
        for i = 1:NFeatures
            test_data(row_r, i) = cumulants(row, i);
        end
        test_data(row_r, NFeatures+1) = 1;
        test_data(row_r, NFeatures+2) = EsNo;
    end
    % psk8
    signalData = zeros(NTest, L);
    noiseData = zeros(NTest, L);
    mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        h = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signalData(row, col) = sqrt(P)*h*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    cumulants = func_get_cumulants(signalData, noiseData);
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+2*NTest+row;
        for i = 1:NFeatures
            test_data(row_r, i) = cumulants(row, i);
        end
        test_data(row_r, NFeatures+1) = 2;
        test_data(row_r, NFeatures+2) = EsNo;
    end
    % qam16
    signalData = zeros(NTest, L);
    noiseData = zeros(NTest, L);
    mod = comm.RectangularQAMModulator('ModulationOrder',16,...
        'NormalizationMethod','Average power','AveragePower',1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:NTest
        h = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signalData(row, col) = sqrt(P)*h*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    cumulants = func_get_cumulants(signalData, noiseData);
    for row = 1:NTest
        row_r = (idx-1)*NClass*NTest+3*NTest+row;
        for i = 1:NFeatures
            test_data(row_r, i) = cumulants(row, i);
        end
        test_data(row_r, NFeatures+1) = 3;
        test_data(row_r, NFeatures+2) = EsNo;
    end
end

csvwrite('test.csv', test_data);
clear
clc

%% init
N = 1000;
Phase_low = 0;
Phase_high = 90;
gap = 5;
L = 250;
EsNo = 12;
P = 10^(EsNo/10);
NClass = 4;
j = sqrt(-1);
phase_array = Phase_low:gap:Phase_high;
acc_array = zeros(1, length(phase_array));

%% get acc_array
for idx = 1:length(phase_array)
    PhaseBound = phase_array(idx)*pi/180;
    fprintf("PhaseBound = %f\n", phase_array(idx));
    fprintf("PhaseBound = %f\n", PhaseBound);
    confusion_cnt = zeros(NClass, NClass); % bpsk, pam4, psk8, qam16
    %% bpsk
    signalData = zeros(N, L);
    noiseData = zeros(N, L);
    mod = comm.BPSKModulator();
    x = constellation(mod);
    xN = length(x);
    for row = 1:N
        for col = 1:L
            s = x(unidrnd(xN));
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signalData(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:N
        C20 = sum(signalData(row,:).^2)/L;
        C21 = sum(abs(signalData(row,:)).^2)/L;
        C21 = C21 - var(noiseData(row,:));
        C40 = sum(signalData(row,:).^4)/L - 3*(C20^2);
        C40_norm = C40/(C21^2);
        % bpsk, pam4, psk8, qam16
        if abs(C40_norm) < 0.34
            confusion_cnt(1, 3) = confusion_cnt(1, 3) + 1;
        elseif abs(C40_norm) >= 0.34 && abs(C40_norm) < 1.02
            confusion_cnt(1, 4) = confusion_cnt(1, 4) + 1;
        elseif abs(C40_norm) >= 1.02 && abs(C40_norm) < 1.68
            confusion_cnt(1, 2) = confusion_cnt(1, 2) + 1;
        else
            confusion_cnt(1, 1) = confusion_cnt(1, 1) + 1;
        end
    end
    %% pam4
    signalData = zeros(N, L);
    noiseData = zeros(N, L);
    mod = comm.PAMModulator('ModulationOrder',4,'NormalizationMethod',...
        'Average power','AveragePower',1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:N
        for col = 1:L
            s = x(unidrnd(xN));
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signalData(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:N
        C20 = sum(signalData(row,:).^2)/L;
        C21 = sum(abs(signalData(row,:)).^2)/L;
        C21 = C21 - var(noiseData(row,:));
        C40 = sum(signalData(row,:).^4)/L - 3*(C20^2);
        C40_norm = C40/(C21^2);
        if abs(C40_norm) < 0.34
            confusion_cnt(2, 3) = confusion_cnt(2, 3) + 1;
        elseif abs(C40_norm) >= 0.34 && abs(C40_norm) < 1.02
            confusion_cnt(2, 4) = confusion_cnt(2, 4) + 1;
        elseif abs(C40_norm) >= 1.02 && abs(C40_norm) < 1.68
            confusion_cnt(2, 2) = confusion_cnt(2, 2) + 1;
        else
            confusion_cnt(2, 1) = confusion_cnt(2, 1) + 1;
        end
    end
    %% psk8
    signalData = zeros(N, L);
    noiseData = zeros(N, L);
    mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
    x = constellation(mod);
    xN = length(x);
    for row = 1:N
        for col = 1:L
            s = x(unidrnd(xN));
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signalData(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:N
        C20 = sum(signalData(row,:).^2)/L;
        C21 = sum(abs(signalData(row,:)).^2)/L;
        C21 = C21 - var(noiseData(row,:));
        C40 = sum(signalData(row,:).^4)/L - 3*(C20^2);
        C40_norm = C40/(C21^2);
        if abs(C40_norm) < 0.34
            confusion_cnt(3, 3) = confusion_cnt(3, 3) + 1;
        elseif abs(C40_norm) >= 0.34 && abs(C40_norm) < 1.02
            confusion_cnt(3, 4) = confusion_cnt(3, 4) + 1;
        elseif abs(C40_norm) >= 1.02 && abs(C40_norm) < 1.68
            confusion_cnt(3, 2) = confusion_cnt(3, 2) + 1;
        else
            confusion_cnt(3, 1) = confusion_cnt(3, 1) + 1;
        end
    end
    %% qam16
    signalData = zeros(N, L);
    noiseData = zeros(N, L);
    mod = comm.RectangularQAMModulator('ModulationOrder',16,...
        'NormalizationMethod','Average power','AveragePower',1);
    x = constellation(mod);
    xN = length(x);
    for row = 1:N
        for col = 1:L
            s = x(unidrnd(xN));
            phase_jitter = 2*PhaseBound*rand() - PhaseBound;
            signalData(row, col) = sqrt(P)*exp(j*phase_jitter)*s + sqrt(1/2)*(randn+j*randn);
            noiseData(row, col) = sqrt(1/2)*(randn+j*randn);
        end
    end
    for row = 1:N
        C20 = sum(signalData(row,:).^2)/L;
        C21 = sum(abs(signalData(row,:)).^2)/L;
        C21 = C21 - var(noiseData(row,:));
        C40 = sum(signalData(row,:).^4)/L - 3*(C20^2);
        C40_norm = C40/(C21^2);
        if abs(C40_norm) < 0.34
            confusion_cnt(4, 3) = confusion_cnt(4, 3) + 1;
        elseif abs(C40_norm) >= 0.34 && abs(C40_norm) < 1.02
            confusion_cnt(4, 4) = confusion_cnt(4, 4) + 1;
        elseif abs(C40_norm) >= 1.02 && abs(C40_norm) < 1.68
            confusion_cnt(4, 2) = confusion_cnt(4, 2) + 1;
        else
            confusion_cnt(4, 1) = confusion_cnt(4, 1) + 1;
        end
    end
    cnt = 0;
    for idx2 = 1:NClass
        cnt = cnt + confusion_cnt(idx2, idx2);
    end
    acc_array(idx) = cnt/(NClass*N);
    fprintf("acc = %f\n", acc_array(idx));
end

%% figure out
fig1 = figure(1);
plot(phase_array, acc_array, '-x');
hold on;
axis([Phase_low Phase_high 0 1]);
%legend('phase_jitter', 'Location', 'southeast');
grid on;
saveas(fig1, 'paper_re_simulation_3.jpg')
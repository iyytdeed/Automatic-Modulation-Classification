clear
close all

LineWidth = 1.2;
MarkerSize = 6;

fc=30000000;
fd=6000000;
fs=fix(6*fc/fd)*fd;
Ts=1/fs;
Td=1/fd;
N=round(Td/Ts);
M = 256;
Nsample = M*N;
T0 = Nsample*Ts;
t = Ts:Ts:T0;

Nclass = 6;
MonteCarloSum = 10;
GammaMax = zeros(MonteCarloSum, Nclass);
SigmaAP = zeros(MonteCarloSum, Nclass);
SigmaDP = zeros(MonteCarloSum, Nclass);
SigmaAA = zeros(MonteCarloSum, Nclass);
SigmaAF = zeros(MonteCarloSum, Nclass);

SNR_array = 0:2:20;
GammaMax_array = zeros(Nclass, length(SNR_array));
SigmaAP_array = zeros(Nclass, length(SNR_array));
SigmaDP_array = zeros(Nclass, length(SNR_array));
SigmaAA_array = zeros(Nclass, length(SNR_array));
SigmaAF_array = zeros(Nclass, length(SNR_array));
for idx = 1:length(SNR_array)
    SNR = SNR_array(idx)
    for MonteCarloCur = 1:MonteCarloSum
        % 2ASK signal
        G = randi([0,1],[1,M]);
        y = Digit_Modul(G, fd, fc, 'ASK', 2);
        [GammaMax(MonteCarloCur, 1), SigmaAP(MonteCarloCur, 1), ...
            SigmaDP(MonteCarloCur, 1), SigmaAA(MonteCarloCur, 1), ...
            SigmaAF(MonteCarloCur, 1)] = getFeature(y, SNR, fc, fs, fd);
        
        % 4ASK signal
        G = randi([0,3],[1,M]);
        y = Digit_Modul(G, fd, fc, 'ASK', 4);
        [GammaMax(MonteCarloCur, 2), SigmaAP(MonteCarloCur, 2), ...
            SigmaDP(MonteCarloCur, 2), SigmaAA(MonteCarloCur, 2), ...
            SigmaAF(MonteCarloCur, 2)] = getFeature(y, SNR, fc, fs, fd);
        
        % 2PSK signal
        G = randi([0,1],[1,M]);
        y = Digit_Modul(G, fd, fc, 'PSK', 2);
        [GammaMax(MonteCarloCur, 3), SigmaAP(MonteCarloCur, 3), ...
            SigmaDP(MonteCarloCur, 3), SigmaAA(MonteCarloCur, 3), ...
            SigmaAF(MonteCarloCur, 3)] = getFeature(y, SNR, fc, fs, fd);
        
        % 4PSK signal
        G = randi([0,3],[1,M]);
        y = Digit_Modul(G, fd, fc, 'PSK', 4);
        [GammaMax(MonteCarloCur, 4), SigmaAP(MonteCarloCur, 4), ...
            SigmaDP(MonteCarloCur, 4), SigmaAA(MonteCarloCur, 4), ...
            SigmaAF(MonteCarloCur, 4)] = getFeature(y, SNR, fc, fs, fd);
        
        % 2FSK signal
        G = randi([0,1],[1,M]);
        y = Digit_Modul(G, fd, fc, 'FSK', 2);
        [GammaMax(MonteCarloCur, 5), SigmaAP(MonteCarloCur, 5), ...
            SigmaDP(MonteCarloCur, 5), SigmaAA(MonteCarloCur, 5), ...
            SigmaAF(MonteCarloCur, 5)] = getFeature(y, SNR, fc, fs, fd);
        
        % 4FSK signal
        G = randi([0,3],[1,M]);
        y = Digit_Modul(G, fd, fc, 'FSK', 4);
        [GammaMax(MonteCarloCur, 6), SigmaAP(MonteCarloCur, 6), ...
            SigmaDP(MonteCarloCur, 6), SigmaAA(MonteCarloCur, 6), ...
            SigmaAF(MonteCarloCur, 6)] = getFeature(y, SNR, fc, fs, fd);
    end
    
    for i = 1:Nclass
    GammaMax_array(i,idx) = mean(GammaMax(:,i));
    SigmaAP_array(i,idx) = mean(SigmaAP(:,i));
    SigmaDP_array(i,idx) = mean(SigmaDP(:,i));
    SigmaAA_array(i,idx) = mean(SigmaAA(:,i));
    SigmaAF_array(i,idx) = mean(SigmaAF(:,i));
    end
end

%% figure out
% GammaMax
fig = figure(1);
plot(SNR_array, GammaMax_array(1,:), '-bo', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, GammaMax_array(2,:), '-bs', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, GammaMax_array(3,:), '-b^', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, GammaMax_array(4,:), '-bv', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, GammaMax_array(5,:), '-rd', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, GammaMax_array(6,:), '-rp', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
GammaMax_threshold = 2*ones(length(SNR_array));
plot(SNR_array, GammaMax_threshold(1,:), '--k', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
legend('2ask','4ask','2psk','4psk','2fsk','4fsk','t(\gamma_{max})','Location','northwest');
xlabel('SNR(dB)');
ylabel('\gamma_{max}');
grid on;
saveas(fig, ['GammaMax', '.jpg'])
csvwrite(['GammaMax', '.txt'], [SNR_array; GammaMax_array]);

% SigmaAA
fig = figure(2);
plot(SNR_array, SigmaAA_array(1,:), '-bo', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, SigmaAA_array(2,:), '-rs', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
SigmaAA_threshold = 0.19*ones(length(SNR_array));
plot(SNR_array, SigmaAA_threshold(1,:), '--k', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
legend('2ask','4ask','t(\sigma_{aa})','Location','southwest');
xlabel('SNR(dB)');
ylabel('\sigma_{aa}');
grid on;
saveas(fig, ['SigmaAA', '.jpg'])
csvwrite(['SigmaAA', '.txt'], [SNR_array; SigmaAA_array]);

% SigmaAP
fig = figure(3);
plot(SNR_array, SigmaAP_array(3,:), '-bd', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, SigmaAP_array(4,:), '-rp', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
SigmaAP_threshold = 0.6*ones(length(SNR_array));
plot(SNR_array, SigmaAP_threshold(1,:), '--k', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
legend('2psk','4psk','t(\sigma_{ap})','Location','southwest');
xlabel('SNR(dB)');
ylabel('\sigma_{ap}');
grid on;
saveas(fig, ['SigmaAP', '.jpg'])
csvwrite(['SigmaAP', '.txt'], [SNR_array; SigmaAP_array]);

% SigmaDP
fig = figure(4);
plot(SNR_array, SigmaDP_array(1,:), '-b^', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, SigmaDP_array(2,:), '-bv', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, SigmaDP_array(3,:), '-rd', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, SigmaDP_array(4,:), '-rp', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
SigmaDP_threshold = 1*ones(length(SNR_array));
plot(SNR_array, SigmaDP_threshold(1,:), '--k', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
legend('2ask','4ask','2psk','4psk','t(\sigma_{dp})','Location','southwest');
xlabel('SNR(dB)');
ylabel('\sigma_{dp}');
grid on;
saveas(fig, ['SigmaDP', '.jpg'])
csvwrite(['SigmaDP', '.txt'], [SNR_array; SigmaDP_array]);

% SigmaAF
fig = figure(5);
plot(SNR_array, SigmaAF_array(5,:), '-bd', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
plot(SNR_array, SigmaAF_array(6,:), '-rp', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
SigmaAF_threshold = 0.85*ones(length(SNR_array));
plot(SNR_array, SigmaAF_threshold(1,:), '--k', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize);
hold on;
legend('2fsk','4fsk','t(\sigma_{af})','Location','northeast');
xlabel('SNR(dB)');
ylabel('\sigma_{af}');
grid on;
saveas(fig, ['SigmaAF', '.jpg'])
csvwrite(['SigmaAF', '.txt'], [SNR_array; SigmaAF_array]);

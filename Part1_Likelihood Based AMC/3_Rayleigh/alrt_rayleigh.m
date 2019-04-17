% ALRT-UB
%   Modulation Classification for {BPSK, 4PAM, 8PAM, 4PSK, 8PSK, 4QAM, 16QAM, 64QAM}
%   4 Classes. Rayleigh Fading Channel.
% Time: 2018.7.2
% Author: ZK Lei
clear;
close all;
clc;
%% init
j = sqrt(-1);
lo = -10;
hi = 20;
gap = 2;
N = 1000;
L = 100;
n_class = 4;
process = 0

%% BPSK Begin
mod = comm.BPSKModulator();
x = constellation(mod);
xN = length(x);
acc_bpsk = zeros(1,(hi - lo)/gap);
h = zeros(N, 1);
for EsNo = lo:gap:hi
    P = 10^(EsNo/10);
    % step_1 gen data
    signal_data = zeros(N, L);
    for row = 1:N
        h(row, 1) = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*h(row, 1)*s + sqrt(1/2)*(randn+j*randn);
        end
    end
    % step_2 run algorithm and get predict res
    r_cnt = 0;
    parfor n = 1:N
        likelihood_bpsk = func_alrt_bpsk(signal_data(n,:), P, h(n,1));
        likelihood_psk8 = func_alrt_psk8(signal_data(n,:), P, h(n,1));
        likelihood_qam4 = func_alrt_qam4(signal_data(n,:), P, h(n,1));
        likelihood_qam16 = func_alrt_qam16(signal_data(n,:), P, h(n,1));
        likelihood = [likelihood_bpsk, likelihood_psk8, likelihood_qam4,...
                      likelihood_qam16];
        maxVal = max(likelihood);
        if(maxVal == likelihood_bpsk)
            r_cnt = r_cnt + 1;
        end
    end
    % step_3 cal acc rate
    idx = (EsNo - lo)/gap + 1;
    acc_bpsk(idx) = r_cnt/N;
end
process = 1

%% PSK8 Begin
mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
x = constellation(mod);
xN = length(x);
acc_psk8 = zeros(1,(hi - lo)/gap);
h = zeros(N, 1);
for EsNo = lo:gap:hi
    P = 10^(EsNo/10);
    % step_1 gen data
    signal_data = zeros(N, L);
    for row = 1:N
        h(row, 1) = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*h(row, 1)*s + sqrt(1/2)*(randn+j*randn);
        end
    end
    % step_2 run algorithm and get predict res
    r_cnt = 0;
    parfor n = 1:N
        likelihood_bpsk = func_alrt_bpsk(signal_data(n,:), P, h(n,1));
        likelihood_psk8 = func_alrt_psk8(signal_data(n,:), P, h(n,1));
        likelihood_qam4 = func_alrt_qam4(signal_data(n,:), P, h(n,1));
        likelihood_qam16 = func_alrt_qam16(signal_data(n,:), P, h(n,1));
        likelihood = [likelihood_bpsk, likelihood_psk8, likelihood_qam4,...
                      likelihood_qam16];
        maxVal = max(likelihood);
        if(maxVal == likelihood_psk8)
            r_cnt = r_cnt + 1;
        end
    end
    % step_3 cal acc rate
    idx = (EsNo - lo)/gap + 1;
    acc_psk8(idx) = r_cnt/N;
end
process = 2

%% QAM4 Begin
mod = comm.RectangularQAMModulator('ModulationOrder',4,...
    'NormalizationMethod','Average power','AveragePower',1);
x = constellation(mod);
xN = length(x);
acc_qam4 = zeros(1,(hi - lo)/gap);
h = zeros(N, 1);
for EsNo = lo:gap:hi
    P = 10^(EsNo/10);
    % step_1 gen data
    signal_data = zeros(N, L);
    for row = 1:N
        h(row, 1) = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*h(row, 1)*s + sqrt(1/2)*(randn+j*randn);
        end
    end
    % step_2 run algorithm and get predict res
    r_cnt = 0;
    parfor n = 1:N
        likelihood_bpsk = func_alrt_bpsk(signal_data(n,:), P, h(n,1));
        likelihood_psk8 = func_alrt_psk8(signal_data(n,:), P, h(n,1));
        likelihood_qam4 = func_alrt_qam4(signal_data(n,:), P, h(n,1));
        likelihood_qam16 = func_alrt_qam16(signal_data(n,:), P, h(n,1));
        likelihood = [likelihood_bpsk, likelihood_psk8, likelihood_qam4,...
                      likelihood_qam16];
        maxVal = max(likelihood);
        if(maxVal == likelihood_qam4)
            r_cnt = r_cnt + 1;
        end
    end
    % step_3 cal acc rate
    idx = (EsNo - lo)/gap + 1;
    acc_qam4(idx) = r_cnt/N;
end
process = 3

%% QAM16 Begin
mod = comm.RectangularQAMModulator('ModulationOrder',16,...
    'NormalizationMethod','Average power','AveragePower',1);
x = constellation(mod);
xN = length(x);
acc_qam16 = zeros(1,(hi - lo)/gap);
h = zeros(N, 1);
for EsNo = lo:gap:hi
    P = 10^(EsNo/10);
    % step_1 gen data
    signal_data = zeros(N, L);
    for row = 1:N
        h(row, 1) = sqrt(1/2)*(randn+j*randn);
        for col = 1:L
            s = x(unidrnd(xN));
            signal_data(row, col) = sqrt(P)*h(row, 1)*s + sqrt(1/2)*(randn+j*randn);
        end
    end
    % step_2 run algorithm and get predict res
    r_cnt = 0;
    parfor n = 1:N
        likelihood_bpsk = func_alrt_bpsk(signal_data(n,:), P, h(n,1));
        likelihood_psk8 = func_alrt_psk8(signal_data(n,:), P, h(n,1));
        likelihood_qam4 = func_alrt_qam4(signal_data(n,:), P, h(n,1));
        likelihood_qam16 = func_alrt_qam16(signal_data(n,:), P, h(n,1));
        likelihood = [likelihood_bpsk, likelihood_psk8, likelihood_qam4,...
                      likelihood_qam16];
        maxVal = max(likelihood);
        if(maxVal == likelihood_qam16)
            r_cnt = r_cnt + 1;
        end
    end
    % step_3 cal acc rate
    idx = (EsNo - lo)/gap + 1;
    acc_qam16(idx) = r_cnt/N;
end
process = 4

%% Res Plot
acc = (acc_bpsk + acc_psk8 + ...
    acc_qam4 + acc_qam16) / n_class;
x_axis = lo:gap:hi;
fig_1 = figure(1);
plot(x_axis, acc, 'o-');
axis([lo, hi, 0, 1]);
% fig_2 = figure(2);
% plot(x_axis, acc_bpsk, '^-');hold on;
% plot(x_axis, acc_qam4, 's-');hold on;
% plot(x_axis, acc_psk8, 'o-');hold on;
% plot(x_axis, acc_qam16, 'h-');hold on;
% axis([lo, hi, 0, 1]);
% grid on;
% legend('BPSK', '4QAM', '8PSK', '16QAM',...
%     'location','southeast');
saveas(fig_1, ['acc_alrt-ub_all_L', num2str(L)], 'png');
% saveas(fig_2, ['acc_alrt-ub_part_L', num2str(L)], 'png');
csvwrite(['acc_alrt-ub_all_L', num2str(L), '.txt'], [x_axis; acc]);
% csvwrite(['acc_alrt-ub_part_L', num2str(L), '.txt'],...
%     [x_axis; acc_bpsk; acc_qam4; acc_psk8;...
%     acc_qam16]);

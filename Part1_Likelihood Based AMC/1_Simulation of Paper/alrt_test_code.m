% ALRT_TEST_CODE
% Test Paper - on the likelihood-based approach to modulation
%   classification - Fig 6. ALRT-UB for {BPSK, QPSK}
% Test pass
% Time: 2018.5.25
% Author: ZK Lei
clear;
close all;
clc;
%% init
j = sqrt(-1);
lo = -8;
hi = 0;
gap = 1;
N = 1000;
L = 100;

%% BPSK Begin
mod = comm.BPSKModulator();
x = constellation(mod);
x_N = length(x);
acc_bpsk = zeros(1,(hi - lo)/gap);
for EsNo = lo:gap:hi
    r_cnt = 0;
    parfor seqIdx = 1:N
        % step_1 gen data
        seq = zeros(1, L);
        h = exp(j*(1/2/pi*rand() - 1/4/pi));
        P = 10^(EsNo/10); % EsNo
        for col = 1:x_N:(N*L)
            for i = 1:x_N
                noise = sqrt(1/2)*(randn+j*randn);
                seq(col+i-1) = sqrt(P)*h*x(i) + noise;
            end
        end
        seq = seq(:,randperm(L)); % suff by col
        
        % step_2 run algorithm and get predict res
        likelihood_bpsk = func_alrt_bpsk(seq, P, h);
        likelihood_qam4 = func_alrt_qam4(seq, P, h);
        likelihood = [likelihood_bpsk, likelihood_qam4];
        maxVal = max(likelihood);
        if(maxVal == likelihood_bpsk)
            r_cnt = r_cnt + 1;
        end
    end
    % step_3 cal acc rate
    idx = (EsNo - lo)/gap + 1;
    acc_bpsk(idx) = r_cnt/N;
end

%% QPSK Begin
mod = comm.RectangularQAMModulator('ModulationOrder',4,...
    'NormalizationMethod','Average power','AveragePower',1);
x = constellation(mod);
x_N = length(x);
acc_qam4 = zeros(1,(hi - lo)/gap);
for EsNo = lo:gap:hi
    r_cnt = 0;
    parfor seqIdx = 1:N
        % step_1 gen data
        seq = zeros(1, L);
        h = exp(j*(1/2/pi*rand() - 1/4/pi));
        P = 10^(EsNo/10); % EsNo
        for col = 1:x_N:(N*L)
            for i = 1:x_N
                noise = sqrt(1/2)*(randn+j*randn);
                seq(col+i-1) = sqrt(P)*h*x(i) + noise;
            end
        end
        seq = seq(:,randperm(L)); % suff by col
        
        % step_2 run algorithm and get predict res
        likelihood_bpsk = func_alrt_bpsk(seq, P, h);
        likelihood_qam4 = func_alrt_qam4(seq, P, h);
        likelihood = [likelihood_bpsk, likelihood_qam4];
        maxVal = max(likelihood);
        if(maxVal == likelihood_qam4)
            r_cnt = r_cnt + 1;
        end
    end
    % step_3 cal acc rate
    idx = (EsNo - lo)/gap + 1;
    acc_qam4(idx) = r_cnt/N;
end

%% Res Plot
acc = (acc_bpsk + acc_qam4)/2;
x_axis = lo:gap:hi;
plot(x_axis, acc, 'o-');
grid on;
hold on;
% plot(x_axis, acc_bpsk, '^-');hold on;
% plot(x_axis, acc_qam4, 's-');hold on;
axis([lo, hi, 0.8, 1]);

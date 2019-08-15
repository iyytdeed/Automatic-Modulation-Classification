function [GammaMax, SigmaAP, SigmaDP, SigmaAA, SigmaAF] = getFeature(y, SNR, fc, fs, fd)
ynoise = awgn(y, SNR, 'measured');
Nsample = size(y, 2);

%% get GammaMax SigmaAA
z = hilbert(ynoise);
amp = abs(z);
ma = mean(amp);
amp_n = amp/ma;
amp_cn = amp_n - 1;

GammaMax = max(abs(fft(amp_cn)))^2/Nsample;
SigmaAA = sqrt(mean(amp_cn.^2) - (mean(abs(amp_cn)))^2);

%% get SigmaAP SigmaDP
phase = angle(z);
phase_uv = unwrap(phase);
phase_nl = phase_uv - 2*pi*fc*(1:Nsample)/fs;
% Ck = zeros(1, Nsample);
% for i=2:Nsample
%     if phase(i)-phase(i-1) > pi
%         Ck(i)=Ck(i-1)-2*pi;
%     elseif  phase(i-1)-phase(i) > pi
%         Ck(i)=Ck(i-1)+2*pi;
%     else
%         Ck(i)=Ck(i-1);
%     end
% end
% phase_nl = phase + Ck - 2*pi*fc*(1:Nsample)/fs;
for i=1:Nsample
    while phase_nl(i) > pi
        phase_nl(i)=phase_nl(i)-2*pi;
    end
    while phase_nl(i) < -pi
        phase_nl(i)=phase_nl(i)+2*pi;
    end
end

at = 1;
cnt = 0;
sum_lft = 0;
sum_rht_ap = 0;
sum_rht_dp = 0;
for i = 1:Nsample
    if amp_n(i) > at
        cnt = cnt + 1;
        sum_lft = sum_lft + phase_nl(i)^2;
        sum_rht_ap = sum_rht_ap + abs(phase_nl(i));
        sum_rht_dp = sum_rht_dp + phase_nl(i);
    end
end
if cnt == 0
    cnt = 1;
end
SigmaAP = sqrt(sum_lft/cnt - (sum_rht_ap/cnt)^2);
SigmaDP = sqrt(sum_lft/cnt - (sum_rht_dp/cnt)^2);

%% get SigmaAF
freq = zeros(1, Nsample);
for i = 1:(Nsample-1)
    freq(i) = (phase_uv(i+1)-phase_uv(i))*fs/(2*pi);
end
freq(Nsample) = freq(Nsample-1);
mf = mean(freq);
freq_c = freq - mf;
freq_n = freq_c/fd;

cnt = 0;
sum_lft_af = 0;
sum_rht_af = 0;
for i = 10:(Nsample-1)
    if amp_n(i) > at
        cnt = cnt + 1;
        sum_lft_af = sum_lft_af + freq_n(i)^2;
        sum_rht_af = sum_rht_af + abs(freq_n(i));
    end
end
if cnt == 0
    cnt = 1;
end
SigmaAF = sqrt(sum_lft_af/cnt - (sum_rht_af/cnt)^2);

%% debug
% subplot(2,2,1);
% plot(ynoise);
% subplot(2,2,2);
% plot(amp);
% subplot(2,2,3);
% plot(phase_nl);
% subplot(2,2,4);
% plot(freq);

end

function [ret] = func_alrt_bpsk(seq, SNR, h)
% cal likelihood value
L = length(seq);
ret = 1;
mod = comm.BPSKModulator();
x = constellation(mod);
M = length(x);
for i = 1:L
    val_sum = 0;
    r = seq(i);
    for m = 1:M
        val = (1/pi)*exp(-abs(r - sqrt(SNR)*h*x(m))^2);
        val_sum = val_sum + val;
    end
    val_sum = val_sum/M;
    ret = ret * val_sum;
end
ret = real(ret);
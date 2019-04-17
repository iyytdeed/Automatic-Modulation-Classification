function [ret] = func_alrt_psk8(seq, P, h)
% cal likelihood value
L = length(seq);
ret = 1;
mod = comm.PSKModulator('ModulationOrder',8,'PhaseOffset',0);
x = constellation(mod);
M = length(x);
for i = 1:L
    val_sum = 0;
    r = seq(i);
    for m = 1:M
        val = (1/pi)*exp(-abs(r - sqrt(P)*h*x(m))^2);
        val_sum = val_sum + val;
    end
    val_sum = log(val_sum/M);
    ret = ret + val_sum;
end
ret = real(ret);
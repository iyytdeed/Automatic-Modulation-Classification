function [ret] = func_alrt_qam16(seq, P, f0)
% cal likelihood value
j = sqrt(-1);
L = length(seq);
ret = 1;
mod = comm.RectangularQAMModulator('ModulationOrder',16,...
    'NormalizationMethod','Average power','AveragePower',1);
x = constellation(mod);
M = length(x);
for i = 1:L
    val_sum = 0;
    r = seq(i);
    for m = 1:M
        val = (1/pi)*exp(-abs(r - sqrt(P)*exp(j*2*pi*f0*i)*x(m))^2);
        val_sum = val_sum + val;
    end
    val_sum = log(val_sum/M);
    ret = ret + val_sum;
end
ret = real(ret);
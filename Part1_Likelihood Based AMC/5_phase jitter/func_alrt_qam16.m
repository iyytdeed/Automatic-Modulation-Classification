function [ret] = func_alrt_qam16(seq, P)
% cal likelihood value
j = sqrt(-1);
L = length(seq);
ret = 0;
mod = comm.RectangularQAMModulator('ModulationOrder',16,...
    'NormalizationMethod','Average power','AveragePower',1);
x = constellation(mod);
M = length(x);
for i = 1:L
    val_sum = 0;
    r = seq(i);
    for m = 1:M
        syms theta;
        val_func = (1/pi)*exp(-abs(r - sqrt(P)*exp(j*theta)*x(m)).^2);
        val = int(val_func, theta, 0, 2*pi);
        val_sum = val_sum + val;
    end
    val_sum = log(val_sum/M);
    ret = ret + val_sum;
end
ret = real(ret);
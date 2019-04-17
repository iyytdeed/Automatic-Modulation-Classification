clear
clc
%% init
j = sqrt(-1);
N = 1000;
EsNo_low = -5;
EsNo_high = 20;
gap = 1;
L_array = [100, 250, 500];

fig1 = figure(1);
for L = L_array
    fprintf("L = %d is begin\n", L);
    [esno_array, acc_array] = paper_re_2_sup(EsNo_low, EsNo_high, gap, N, L);
    plot(esno_array, acc_array);
    hold on;
    fprintf("L = %d is end\n", L);
end
axis([EsNo_low EsNo_high 0.2 1]);
legend('L = 100', 'L = 250', 'L = 500', 'Location', 'southeast');
grid on;
saveas(fig1, 'paper_re_simulation_2_fig.jpg')
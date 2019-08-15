%------------------------------------------------------------------
% Decision Tree
%------------------------------------------------------------------
function [n_2ask, n_4ask, n_2psk, n_4psk, n_2fsk, n_4fsk]=...
    recognition(Gama_m, Sigma_aa, Sigma_dp, Sigma_ap, Sigma_af, num)
n_2ask=0;
n_4ask=0;
n_2psk=0;
n_4psk=0;
n_2fsk=0;
n_4fsk=0;
for i=1:num
    if Gama_m(i)<2
        if Sigma_af(i)<0.85
            n_2fsk=n_2fsk+1;
        else
            n_4fsk=n_4fsk+1;
        end
    elseif Sigma_dp(i)<1
        if Sigma_aa(i)>=0.19
            n_4ask=n_4ask+1;
        else
            n_2ask=n_2ask+1;
        end
    else
        if Sigma_ap(i)<0.6
            n_2psk=n_2psk+1;
        else
            n_4psk=n_4psk+1;
        end
    end
end
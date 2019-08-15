% G - Symbol Sequence / Frame
% Rb - Symbol Rate / Baud Rate
% fc - Carrier Frequency
% model - 'ASK'/'PSK'/'FSK'/'QAM'
function [Sig_Mod] = Digit_Modul(G, Rb, fc, model, M)
N = fix(6*fc/Rb);
len = size(G,2);
Unit = ones(1,len);
Sig_Mod = zeros(1,len*N);

if model~='QAM'
    % ASK
    if model=='ASK'
        if M==2
            a_theta=0.8*G+0.2*Unit;
            f_theta=fc*Unit;
            phi_theta=0*Unit;
        elseif M==4
            a_theta=0.25*G+0.25*Unit;
            f_theta=fc*Unit;
            phi_theta=0*Unit;
        end
    % PSK
    elseif model=='PSK'
        if M==2
            a_theta=1*Unit;
            f_theta=fc*Unit;
            phi_theta=-pi/2*Unit+pi*G;
            %             phi_theta=pi*G;
        elseif M==4
            a_theta=1*Unit;
            f_theta=fc*Unit;
            phi_theta=pi/4*Unit+pi/2*G;
            %             phi_theta=pi/2*G;
        end
    % FSK
    elseif model=='FSK'
        if M==2
            a_theta=1*Unit;
            f_theta=(fc-Rb)*Unit+2*Rb*G;
            phi_theta=0*Unit;
        elseif M==4
            a_theta=1*Unit;
            f_theta=(fc-3*Rb)*Unit+2*Rb*G;
            phi_theta=0*Unit;
        end
    end
    
    for j=1:len
        for i=1:N
            Sig_Mod(i+(j-1)*N)=a_theta(j)*cos(2*pi*f_theta(j)*(i+(j-1)*N)/(N*Rb)+phi_theta(j));
        end
    end
end
% QAM
if model=='QAM'
    I=-sqrt(2)/2*Unit+sqrt(2)/3*G(1,:);
    Q=-sqrt(2)/2*Unit+sqrt(2)/3*G(2,:);
    for j=1:len
        for i=1:N
            Sig_Mod(i+(j-1)*N)=I(j)*cos(2*pi*fc*i/(N*Rb))+Q(j)*sin(2*pi*fc*i/(N*Rb));
        end
    end
end
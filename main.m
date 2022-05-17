clear all, clc, close all

%% 1 Observacion de una Trama de Bits
Tb = 1e-9;
A=1;
Pa=0.5; % Probabilidad de Bit

a = round(rand(500,1000));
dim = size(a);
for i = 1:dim(1)
    for j = 1:dim(2)
        if a(i,j) == 0
            a(i,j)=-1;
        end
    end
end


%% 2 Construccion de senial PCM s(t)
for i = 1:dim(1)
    [s(i,:) T(i,:)] = LineEncoder('uninrz',a(i,:),Tb,A);
end
figure
plot(T(1,1:10000),s(1,1:10000),'LineWidth',2);grid on;
title('Trama de Bits')
xlabel('t (seg)')
ylabel('s(t)')

% 
% 
% tk=20; % Tiempo de Evaluacion
% tk_tau=50;
% % Autocorrelacion
% mu = 0;
% [c,lags] = xcorr(a(1,tk),a(1,tk_tau));
% 
% 
%% 3 Calculo de Media Promediada
timeAveragedMean = mean(s(1,:));

%% 4 Calculo de la Autocorrelacion promediada
[timeAveragedAutocorrlation,tau] = xcorr(s(1,:),'normalized');

%% 5 Grafica de las Funciones ensemble y promediadas en tiempo
[c,lags] = xcorr(s(:,20),s(:,30),'normalized');

figure
subplot(2,1,1)
plot(lags,c);
title('Función de Autocorrelación')
xlabel('$$\tau$$','interpreter','latex')
ylabel('$$R_{SS}(\tau)$$','interpreter','latex')

subplot(2,1,2)
plot(tau,timeAveragedAutocorrlation);
title('Función de Autocorrelación promediada en el Tiempo')
xlabel('$$\tau$$','interpreter','latex')
ylabel('$$\Re_{SS}(\tau)$$','interpreter','latex')

%% 6 Determinacion de la Densidad Espectral de Potencia

Y = fft(timeAveragedAutocorrlation)
Fs = 1/Tb;            % Sampling frequency                    
L = length(tau);             % Length of signal
f = Fs*(0:(L/2))/L;
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


%% 7 Graficas de PSD y Periodograma
periodograma = (1/L)*(P1.^2);

figure
subplot(2,1,1)
plot(f(1:L/4),P1(1:L/4)) 
title('Densidad Espectral de potencia')
xlabel('f (Hz)')
ylabel('$$S(f)$$','interpreter','latex')

subplot(2,1,2)
plot(f(1:L/4),periodograma(1:L/4)) 
title('Estimación de S(f)')
xlabel('f [Hz]')
ylabel('$$\hat{S}_{SS}(f)$$','interpreter','latex')
